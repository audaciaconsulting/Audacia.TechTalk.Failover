resource "azurerm_linux_web_app" "app_service_ui" {
  name                = var.web_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.app_service_plan_id

  site_config {
    application_stack {
      node_version = var.node_version
    }

    app_command_line = "npx serve -s"

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
    WEBSITE_ENABLE_SYNC_UPDATE_SITE = "true"
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      virtual_network_subnet_id
    ]
  }
}

resource "azurerm_linux_web_app_slot" "app_service_ui_slot" {
  name           = "staging"
  app_service_id = azurerm_linux_web_app.app_service_ui.id

  site_config {
    application_stack {
      node_version = var.node_version
    }

    app_command_line = "npx serve -s"

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
    WEBSITE_ENABLE_SYNC_UPDATE_SITE = "true"
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      virtual_network_subnet_id
    ]
  }
}