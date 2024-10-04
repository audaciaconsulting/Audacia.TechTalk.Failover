resource "azurerm_cdn_frontdoor_profile" "front_door_profile" {
  name                = "${var.full_name}-afd"
  resource_group_name = var.resource_group_name
  sku_name            = var.front_door_sku_name
}

# Office Portal
resource "azurerm_cdn_frontdoor_endpoint" "front_door_portal_endpoint" {
  name                     = "${var.full_name}-portal-fde"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.front_door_profile.id
}

# Portal API Origin Group
resource "azurerm_cdn_frontdoor_origin_group" "portal_api_origin_group" {
  name                     = "${var.full_name}-portal-api-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.front_door_profile.id
  session_affinity_enabled = false

  health_probe {
    interval_in_seconds = 15
    path                = "/health"
    protocol            = "Https"
    request_type        = "HEAD"
  }

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }
}

resource "azurerm_cdn_frontdoor_origin" "portal_api_uksouth_origin" {
  name                          = "${var.full_name}-portal-api-uksouth-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.portal_api_origin_group.id

  enabled                        = true
  host_name                      = var.portal_api_uksouth_hostname
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = var.portal_api_uksouth_hostname
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = true
}

resource "azurerm_cdn_frontdoor_origin" "portal_api_ukwest_origin" {
  name                          = "${var.full_name}-portal-api-ukwest-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.portal_api_origin_group.id

  enabled                        = true
  host_name                      = var.portal_api_ukwest_hostname
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = var.portal_api_ukwest_hostname
  priority                       = 2
  weight                         = 1000
  certificate_name_check_enabled = true
}

# Portal UI Origin Group
resource "azurerm_cdn_frontdoor_origin_group" "portal_ui_origin_group" {
  name                     = "${var.full_name}-portal-ui-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.front_door_profile.id
  session_affinity_enabled = false

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }
}

resource "azurerm_cdn_frontdoor_origin" "portal_ui_uksouth_origin" {
  name                          = "${var.full_name}-portal-ui-uksouth-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.portal_ui_origin_group.id

  enabled                        = true
  host_name                      = var.portal_ui_uksouth_hostname
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = var.portal_ui_uksouth_hostname
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = true
}

resource "azurerm_cdn_frontdoor_origin" "portal_ui_ukwest_origin" {
  name                          = "${var.full_name}-portal-ui-ukwest-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.portal_ui_origin_group.id

  enabled                        = true
  host_name                      = var.portal_ui_ukwest_hostname
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = var.portal_ui_ukwest_hostname
  priority                       = 2
  weight                         = 1000
  certificate_name_check_enabled = true
}

# Portal Domains
resource "azurerm_cdn_frontdoor_custom_domain" "portal_ui_domain" {
  name                     = "tech-talk-portal-ui-domain"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.front_door_profile.id
  host_name                = "portal.${var.tech_talks_domain}"

  tls {
    certificate_type    = "ManagedCertificate"
    minimum_tls_version = "TLS12"
  }
}

resource "azurerm_cdn_frontdoor_custom_domain" "portal_api_domain" {
  name                     = "tech-talk-portal-api-domain"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.front_door_profile.id
  host_name                = "api.portal.${var.tech_talks_domain}"

  tls {
    certificate_type    = "ManagedCertificate"
    minimum_tls_version = "TLS12"
  }
}

resource "azurerm_cdn_frontdoor_route" "portal_api_route" {
  name                          = "${var.full_name}-portal-api-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.front_door_portal_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.portal_api_origin_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.portal_api_uksouth_origin.id, azurerm_cdn_frontdoor_origin.portal_api_ukwest_origin.id]
  
  enabled = true

  https_redirect_enabled = true
  patterns_to_match      = ["/*"]
  supported_protocols    = ["Http", "Https"]
  link_to_default_domain          = false

  cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.portal_api_domain.id]
}

resource "azurerm_cdn_frontdoor_route" "portal_ui_route" {
  name                          = "${var.full_name}-portal-ui-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.front_door_portal_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.portal_ui_origin_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.portal_ui_uksouth_origin.id, azurerm_cdn_frontdoor_origin.portal_ui_ukwest_origin.id]

  enabled = true

  https_redirect_enabled = true
  patterns_to_match      = ["/*"]
  supported_protocols    = ["Http", "Https"]
  link_to_default_domain          = false

  cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.portal_ui_domain.id]
}

# add a TXT record to DNS to validate the domain
resource "azurerm_dns_txt_record" "portal_ui_domain_verification" {
  count               = var.create_dns_records ? 1 : 0
  name                = "_dnsauth.portal"
  zone_name           = var.tech_talks_domain
  resource_group_name = var.resource_group_name
  ttl                 = 300

  record {
    value = azurerm_cdn_frontdoor_custom_domain.portal_ui_domain.validation_token
  }
}

resource "azurerm_dns_txt_record" "portal_api_domain_verification" {
  count               = var.create_dns_records ? 1 : 0
  name                = "_dnsauth.api.portal"
  zone_name           = var.tech_talks_domain
  resource_group_name = var.resource_group_name
  ttl                 = 300

  record {
    value = azurerm_cdn_frontdoor_custom_domain.portal_api_domain.validation_token
  }
}

# create CNAME record 
resource "azurerm_dns_cname_record" "portal-ui-cname" {
  count               = var.create_dns_records ? 1 : 0
  name                = "portal"
  zone_name           = var.tech_talks_domain
  resource_group_name = var.resource_group_name
  ttl                 = 300
  record              = azurerm_cdn_frontdoor_endpoint.front_door_portal_endpoint.host_name
}

# create CNAME record 
resource "azurerm_dns_cname_record" "portal-api-cname" {
  count               = var.create_dns_records ? 1 : 0
  name                = "api.portal"
  zone_name           = var.tech_talks_domain
  resource_group_name = var.resource_group_name
  ttl                 = 300
  record              = azurerm_cdn_frontdoor_endpoint.front_door_portal_endpoint.host_name
}

resource "azurerm_cdn_frontdoor_firewall_policy" "firewall_policy" {
  count               = var.front_door_sku_name == "Premium_AzureFrontDoor" ? 1 : 0
  name                = "techtalkdefaultwaf"
  resource_group_name = var.resource_group_name
  sku_name            = azurerm_cdn_frontdoor_profile.front_door_profile.sku_name
  enabled             = true
  mode                = "Prevention"

  managed_rule {
    type    = "Microsoft_DefaultRuleSet"
    version = "2.1"
    action  = "Block"
  }

  managed_rule {
    type    = "Microsoft_BotManagerRuleSet"
    version = "1.0"
    action  = "Block"
  }
}

resource "azurerm_cdn_frontdoor_security_policy" "portal_api_security_policy" {
  count                    = var.front_door_sku_name == "Premium_AzureFrontDoor" ? 1 : 0
  name                     = "Api-Tech-Talk-Security-Policy"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.front_door_profile.id
  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = azurerm_cdn_frontdoor_firewall_policy.firewall_policy[0].id
      association {
        domain {
          cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_custom_domain.portal_api_domain.id
        }
        patterns_to_match = ["/*"]
      }
    }
  }
}

resource "azurerm_cdn_frontdoor_security_policy" "portal_ui_security_policy" {
  count                    = var.front_door_sku_name == "Premium_AzureFrontDoor" ? 1 : 0
  name                     = "Ui-Tech-Talk-Security-Policy"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.front_door_profile.id
  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = azurerm_cdn_frontdoor_firewall_policy.firewall_policy[0].id
      association {
        domain {
          cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_custom_domain.portal_ui_domain.id
        }
        patterns_to_match = ["/*"]
      }
    }
  }
}

# resource "azurerm_monitor_diagnostic_setting" "example" {
#   name                       = "diagnostic"
#   target_resource_id         = azurerm_cdn_frontdoor_profile.front_door_profile.id
#   log_analytics_workspace_id = var.log_anayltics_workspace_id

#   enabled_log {
#     category_group = "AllLogs"
#   }

#   metric {
#     category = "AllMetrics"
#   }
# }