resource "azurerm_linux_web_app" "app_service_api" {
  name                = var.web_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.app_service_plan_id

  site_config {
    application_stack {
      dotnet_version = var.dotnet_version
    }

    vnet_route_all_enabled = true

    # ip_restriction_default_action     = "Deny"
    # scm_ip_restriction_default_action = "Deny"

    # ip_restriction {
    #   action = "Allow"
    #   headers = [{
    #     x_azure_fdid      = [var.front_door_resource_guid]
    #     x_fd_health_probe = []
    #     x_forwarded_for   = []
    #     x_forwarded_host  = []
    #   }]
    #   name        = "FrontDoor"
    #   priority    = 1
    #   service_tag = "AzureFrontDoor.Backend"
    # }

    # scm_ip_restriction {
    #   action                    = "Allow"
    #   name                      = "AllowDeployVNET"
    #   priority                  = 10
    #   virtual_network_subnet_id = var.deploy_subnet_resource_id
    # }
  }

  app_settings = {
    AppConfiguration__Endpoint                 = var.app_configuration_endpoint,
    AppConfiguration__FeatureLabel             = var.app_configuration_feature_label,
    AppConfiguration__ConfigurationLabel       = var.app_configuration_configuration_label,
    APPINSIGHTS_INSTRUMENTATIONKEY             = var.app_insights_instrumentation_key
    ApplicationInsightsAgent_EXTENSION_VERSION = "~2"
    XDT_MicrosoftApplicationInsights_Mode      = "default"
    APPLICATIONINSIGHTS_CONNECTION_STRING      = "InstrumentationKey=${var.app_insights_instrumentation_key}"
    WEBSITE_ENABLE_SYNC_UPDATE_SITE            = "true"
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      app_settings["ASPNETCORE_ENVIRONMENT"],
      virtual_network_subnet_id
    ]
  }
}

resource "azurerm_linux_web_app_slot" "app_service_api_slot" {
  name           = "staging"
  app_service_id = azurerm_linux_web_app.app_service_api.id

  site_config {
    application_stack {
      dotnet_version = var.dotnet_version
    }

    vnet_route_all_enabled = true

    # ip_restriction_default_action     = "Deny"
    # scm_ip_restriction_default_action = "Deny"

    # ip_restriction {
    #   action                    = "Allow"
    #   name                      = "AllowDeployVNET"
    #   priority                  = 10
    #   virtual_network_subnet_id = var.deploy_subnet_resource_id
    # }

    # scm_ip_restriction {
    #   action                    = "Allow"
    #   name                      = "AllowDeployVNET"
    #   priority                  = 10
    #   virtual_network_subnet_id = var.deploy_subnet_resource_id
    # }
  }

  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY             = var.app_insights_instrumentation_key
    ApplicationInsightsAgent_EXTENSION_VERSION = "~2"
    XDT_MicrosoftApplicationInsights_Mode      = "default"
    APPLICATIONINSIGHTS_CONNECTION_STRING      = "InstrumentationKey=${var.app_insights_instrumentation_key}"
    WEBSITE_ENABLE_SYNC_UPDATE_SITE            = "true"
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      app_settings["ASPNETCORE_ENVIRONMENT"],
      virtual_network_subnet_id
    ]
  }
}

# Add Key Vault permission to SystemAssigned Identity
resource "azurerm_role_assignment" "api_kv_secrets_user_role" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_linux_web_app.app_service_api.identity.0.principal_id

  depends_on = [azurerm_linux_web_app.app_service_api]
}

resource "azurerm_role_assignment" "api_staging_kv_secrets_user_role" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_linux_web_app_slot.app_service_api_slot.identity.0.principal_id

  depends_on = [azurerm_linux_web_app_slot.app_service_api_slot]
}

resource "azurerm_role_assignment" "api_kv_crypto_user_role" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Crypto User"
  principal_id         = azurerm_linux_web_app.app_service_api.identity.0.principal_id

  depends_on = [azurerm_linux_web_app.app_service_api]
}

resource "azurerm_role_assignment" "api_staging_kv_crypto_user_role" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Crypto User"
  principal_id         = azurerm_linux_web_app_slot.app_service_api_slot.identity.0.principal_id

  depends_on = [azurerm_linux_web_app_slot.app_service_api_slot]
}

# Add App configuration permission to SystemAssigned Identity
resource "azurerm_role_assignment" "api_app_configuration_data_reader_role" {
  scope                = var.app_configuration_id
  role_definition_name = "App Configuration Data Reader"
  principal_id         = azurerm_linux_web_app.app_service_api.identity.0.principal_id

  depends_on = [azurerm_linux_web_app.app_service_api]
}

resource "azurerm_role_assignment" "api_staging_app_configuration_data_reader_role" {
  scope                = var.app_configuration_id
  role_definition_name = "App Configuration Data Reader"
  principal_id         = azurerm_linux_web_app_slot.app_service_api_slot.identity.0.principal_id

  depends_on = [azurerm_linux_web_app_slot.app_service_api_slot]
}