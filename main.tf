resource "azurerm_application_gateway" "ag" {
  name                = "${local.resource_prefix}aks${format("%02d", count.index)}-${var.env}-agw"
  resource_group_name = var.vnet_rg
  location            = var.location
  tags                = var.common_tags
  zones               = var.enable_multiple_availability_zones == true ? ["1", "2", "3"] : []

  count = length(local.gateways)

  sku {
    name = "Standard_v2"
    tier = "Standard_v2"
  }

  autoscale_configuration {
    min_capacity = var.min_capacity
    max_capacity = var.max_capacity
  }

  gateway_ip_configuration {
    name      = "gateway"
    subnet_id = data.azurerm_subnet.app_gw.id
  }

  frontend_port {
    name = "http"
    port = 80
  }

  frontend_port {
    name = "https"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "appGwPublicFrontendIp"
    public_ip_address_id = element(azurerm_public_ip.app_gw.*.id, count.index)
  }

  frontend_ip_configuration {
    name                          = "appGwPrivateFrontendIp"
    subnet_id                     = data.azurerm_subnet.app_gw.id
    private_ip_address            = element(var.private_ip_address, count.index)
    private_ip_address_allocation = "Static"
  }

  dynamic "backend_address_pool" {
    for_each = [for app in local.gateways[count.index].app_configuration : {
      name = "${app.product}-${app.component}"
    }]

    content {
      name         = backend_address_pool.value.name
      ip_addresses = var.backend_pool_ip_addresses
    }
  }

  dynamic "probe" {
    for_each = [for app in local.gateways[count.index].app_configuration : {
      name                    = "${app.product}-${app.component}"
      path                    = lookup(app, "health_path_override", "/health/liveness")
      host_name_include_env   = join(".", [lookup(app, "host_name_prefix", "${app.product}-${app.component}-${var.env}"), local.gateways[count.index].gateway_configuration.host_name_suffix])
      host_name_exclude_env   = join(".", [lookup(app, "host_name_prefix", "${app.product}-${app.component}"), local.gateways[count.index].gateway_configuration.host_name_suffix])
      ssl_host_name           = join(".", [lookup(app, "host_name_prefix", "${app.product}-${app.component}"), local.gateways[count.index].gateway_configuration.ssl_host_name_suffix])
      ssl_enabled             = contains(keys(app), "ssl_enabled") ? app.ssl_enabled : false
      exclude_env_in_app_name = lookup(local.gateways[count.index].gateway_configuration, "exclude_env_in_app_name", false)
    }]

    content {
      interval            = 10
      name                = probe.value.name
      host                = probe.value.ssl_enabled ? probe.value.ssl_host_name : probe.value.exclude_env_in_app_name ? probe.value.host_name_exclude_env : probe.value.host_name_include_env
      path                = probe.value.path
      protocol            = "Http"
      timeout             = 15
      unhealthy_threshold = 3
    }
  }

  dynamic "backend_http_settings" {
    for_each = [for app in local.gateways[count.index].app_configuration : {
      name                  = "${app.product}-${app.component}"
      cookie_based_affinity = contains(keys(app), "cookie_based_affinity") ? app.cookie_based_affinity : "Disabled"
    }]

    content {
      name                  = backend_http_settings.value.name
      probe_name            = backend_http_settings.value.name
      cookie_based_affinity = backend_http_settings.value.cookie_based_affinity
      port                  = 80
      protocol              = "Http"
      request_timeout       = 30
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.identity.id]
  }

  ssl_certificate {
    name                = local.gateways[count.index].gateway_configuration.certificate_name
    key_vault_secret_id = data.azurerm_key_vault_secret.certificate[count.index].versionless_id
  }

  dynamic "http_listener" {
    for_each = [for app in local.gateways[count.index].app_configuration : {
      name                    = "${app.product}-${app.component}"
      host_name_include_env   = join(".", [lookup(app, "host_name_prefix", "${app.product}-${app.component}-${var.env}"), local.gateways[count.index].gateway_configuration.host_name_suffix])
      host_name_exclude_env   = join(".", [lookup(app, "host_name_prefix", "${app.product}-${app.component}"), local.gateways[count.index].gateway_configuration.host_name_suffix])
      ssl_host_name           = join(".", [lookup(app, "host_name_prefix", "${app.product}-${app.component}"), local.gateways[count.index].gateway_configuration.ssl_host_name_suffix])
      ssl_enabled             = contains(keys(app), "ssl_enabled") ? app.ssl_enabled : false
      ssl_certificate_name    = local.gateways[count.index].gateway_configuration.certificate_name
      exclude_env_in_app_name = lookup(local.gateways[count.index].gateway_configuration, "exclude_env_in_app_name", false)
    }]

    content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = "appGwPrivateFrontendIp"
      frontend_port_name             = http_listener.value.ssl_enabled ? "https" : "http"
      protocol                       = http_listener.value.ssl_enabled ? "Https" : "Http"
      host_name                      = http_listener.value.ssl_enabled ? http_listener.value.ssl_host_name : http_listener.value.exclude_env_in_app_name ? http_listener.value.host_name_exclude_env : http_listener.value.host_name_include_env
      ssl_certificate_name           = http_listener.value.ssl_enabled ? http_listener.value.ssl_certificate_name : ""
    }
  }

  dynamic "http_listener" {
    for_each = [for app in local.gateways[count.index].app_configuration : {
      name      = "${app.product}-${app.component}-redirect"
      host_name = join(".", [lookup(app, "host_name_prefix", "${app.product}-${app.component}"), local.gateways[count.index].gateway_configuration.ssl_host_name_suffix])
      }
      if lookup(app, "http_to_https_redirect", false) == true
    ]

    content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = "appGwPrivateFrontendIp"
      frontend_port_name             = "http"
      protocol                       = "Http"
      host_name                      = http_listener.value.host_name
    }
  }

  dynamic "redirect_configuration" {
    for_each = [for app in local.gateways[count.index].app_configuration : {
      name        = "${app.product}-${app.component}-redirect"
      target_name = "${app.product}-${app.component}"
      }
      if lookup(app, "http_to_https_redirect", false) == true
    ]

    content {
      name                 = redirect_configuration.value.name
      redirect_type        = "Permanent"
      include_path         = true
      include_query_string = true
      target_listener_name = redirect_configuration.value.target_name
    }
  }

  dynamic "request_routing_rule" {
    for_each = [for i, app in local.gateways[count.index].app_configuration : {
      name     = "${app.product}-${app.component}"
      priority = ((i + 1) * 10)
    }]

    content {
      name                       = request_routing_rule.value.name
      rule_type                  = "Basic"
      priority                   = request_routing_rule.value.priority
      http_listener_name         = request_routing_rule.value.name
      backend_address_pool_name  = request_routing_rule.value.name
      backend_http_settings_name = request_routing_rule.value.name
    }
  }

  dynamic "request_routing_rule" {
    for_each = [for i, app in local.gateways[count.index].app_configuration : {
      name     = "${app.product}-${app.component}-redirect"
      priority = ((i + 1) * 10)
      }
      if lookup(app, "http_to_https_redirect", false) == true
    ]

    content {
      name                        = request_routing_rule.value.name
      rule_type                   = "Basic"
      priority                    = request_routing_rule.value.priority
      http_listener_name          = request_routing_rule.value.name
      redirect_configuration_name = request_routing_rule.value.name
    }
  }

  depends_on = [azurerm_role_assignment.identity]
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories" {
  resource_id = azurerm_application_gateway.ag[0].id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_settings" {
  name                       = "AppGw"
  count                      = length(local.gateways)
  target_resource_id         = azurerm_application_gateway.ag[count.index].id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "metric" {
    for_each = [for category in data.azurerm_monitor_diagnostic_categories.diagnostic_categories.metrics : {
      category = category
    }]

    content {
      category = metric.value.category
      enabled  = true
      retention_policy {
        enabled = true
      }
    }
  }
}
