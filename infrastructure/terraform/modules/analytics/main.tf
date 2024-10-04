locals {
  sanitized_location = lower(replace(var.location, " ", ""))
}

resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "${var.full_name}-log-${local.sanitized_location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
}

resource "azurerm_application_insights" "app_insights" {
  name                = "${var.full_name}-appi-${local.sanitized_location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.log_analytics_workspace.id
  application_type    = "web"
}
