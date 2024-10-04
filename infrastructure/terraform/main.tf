locals {
  full_name          = var.ENVIRONMENT == "" ? var.NAME : "${var.NAME}-${var.ENVIRONMENT}"
  sanitized_name     = lower(replace(local.full_name, "-", ""))
  sanitized_location = lower(replace(var.LOCATION, " ", ""))
  upper_location     = upper(var.ENVIRONMENT)
}

terraform {
  backend "azurerm" {
    resource_group_name  = "audacia-devops"
    storage_account_name = "audaciaterraform"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.101.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.10.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {
}

data "azurerm_resource_group" "resource_group" {
  name = var.RESOURCE_GROUP_NAME
}

data "azurerm_key_vault" "key_vault" {
  name                = var.KEY_VAULT_NAME
  resource_group_name = data.azurerm_resource_group.resource_group.name
}

data "azurerm_app_configuration" "app_configuration" {
  name                = var.APP_CONFIGURATION_SERVICE_NAME
  resource_group_name = data.azurerm_resource_group.resource_group.name
}

module "analytics" {
  source = "./modules/analytics"

  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = var.LOCATION
  full_name           = local.full_name
}

module "apps-uksouth" {
  source = "./modules/apps"

  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = "UK South"
  environment         = var.ENVIRONMENT
  full_name           = local.full_name
  sanitized_name      = local.sanitized_name
  sanitized_location  = "uksouth"

  # front_door_resource_guid              = module.front_door.front_door_resource_guid
  app_configuration_id                  = data.azurerm_app_configuration.app_configuration.id
  app_configuration_endpoint            = data.azurerm_app_configuration.app_configuration.endpoint
  app_configuration_configuration_label = var.ENVIRONMENT
  app_configuration_feature_label       = var.ENVIRONMENT
  key_vault_id                          = data.azurerm_key_vault.key_vault.id
  app_insights_instrumentation_key      = module.analytics.instrumentation_key
  asp_plan_sku_name                     = var.ASP_PLAN_SKU_NAME
}

module "apps-ukwest" {
  source = "./modules/apps"

  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = "UK West"
  environment         = var.ENVIRONMENT
  full_name           = local.full_name
  sanitized_name      = local.sanitized_name
  sanitized_location  = "ukwest"

  # front_door_resource_guid              = module.front_door.front_door_resource_guid
  app_configuration_id                  = data.azurerm_app_configuration.app_configuration.id
  app_configuration_endpoint            = data.azurerm_app_configuration.app_configuration.endpoint
  app_configuration_configuration_label = var.ENVIRONMENT
  app_configuration_feature_label       = var.ENVIRONMENT
  key_vault_id                          = data.azurerm_key_vault.key_vault.id
  app_insights_instrumentation_key      = module.analytics.instrumentation_key
  asp_plan_sku_name                     = var.ASP_PLAN_SKU_NAME
}

module "front-door" {
  source                        = "./modules/front-door"
  full_name                     = local.full_name
  portal_api_uksouth_hostname   = module.apps-uksouth.portal_api_hostname
  portal_ui_uksouth_hostname    = module.apps-uksouth.portal_ui_hostname
  portal_api_ukwest_hostname    = module.apps-ukwest.portal_api_hostname
  portal_ui_ukwest_hostname     = module.apps-ukwest.portal_ui_hostname
  resource_group_name           = data.azurerm_resource_group.resource_group.name

  tech_talks_domain             = var.TECH_TALKS_DOMAIN
  create_dns_records            = var.CREATE_DNS_RECORDS
  front_door_sku_name           = var.FRONT_DOOR_SKU_NAME
  log_anayltics_workspace_id    = module.analytics.log_anayltics_workspace_id
}

module "storage" {
  source = "./modules/storage"

  resource_group_name                      = data.azurerm_resource_group.resource_group.name
  full_name                                = local.full_name
  location                                 = "UK South"
  sanitized_name                           = local.sanitized_name
  portal_api_uksouth_principal_id          = module.apps-uksouth.portal_api_identity_principal_id
  portal_api_uksouth_staging_principal_id  = module.apps-uksouth.portal_api_staging_identity_principal_id
  portal_api_ukwest_principal_id           = module.apps-ukwest.portal_api_identity_principal_id
  portal_api_ukwest_staging_principal_id   = module.apps-ukwest.portal_api_staging_identity_principal_id
  environment                              = var.ENVIRONMENT
}