resource "azurerm_service_plan" "app_service_plan" {
  name                = "${var.full_name}-asp-${var.sanitized_location}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = var.asp_plan_sku_name
  os_type             = "Linux"
}

# Portal API
module "portal-api-web-app" {
  source                                = "./modules/api-web-app"
  web_app_name                          = "${var.full_name}-portal-api-app-${var.sanitized_location}"
  resource_group_name                   = var.resource_group_name
  app_insights_instrumentation_key      = var.app_insights_instrumentation_key
  app_configuration_id                  = var.app_configuration_id
  app_configuration_endpoint            = var.app_configuration_endpoint
  app_configuration_configuration_label = var.app_configuration_configuration_label
  app_configuration_feature_label       = var.app_configuration_feature_label
  key_vault_id                          = var.key_vault_id
  app_service_plan_id                   = azurerm_service_plan.app_service_plan.id
  location                              = var.location
  dotnet_version                        = "8.0"
}

# Portal UI
module "portal-ui-web-app" {
  source                           = "./modules/ui-web-app"
  web_app_name                     = "${var.full_name}-portal-ui-app-${var.sanitized_location}"
  resource_group_name              = var.resource_group_name
  app_insights_instrumentation_key = var.app_insights_instrumentation_key
  app_service_plan_id              = azurerm_service_plan.app_service_plan.id
  location                         = var.location
  node_version                     = "20-lts"
}