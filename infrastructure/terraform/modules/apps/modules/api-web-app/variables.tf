variable "app_service_plan_id" {
  type        = string
  description = "The id of the app service plan to create the app in"
}

variable "resource_group_name" {
  type        = string
  description = "The name of resource group to create the app in"
}

variable "location" {
  type        = string
  description = "The Azure location to create the app in"
}

variable "web_app_name" {
  type        = string
  description = "The name of the web app"
}

variable "app_insights_instrumentation_key" {
  type        = string
  description = "The name of the web app"
}

variable "dotnet_version" {
  type        = string
  description = "The dotnetv version"
}

variable "app_configuration_id" {
  type        = string
  description = "The id of the app configuration resource"
}

variable "app_configuration_endpoint" {
  type = string
  description = "The endpoint of the app configuration resource"
}

variable "app_configuration_configuration_label" {
  type = string
  description = "The label for the configuration values of the app configuration resource"
}

variable "app_configuration_feature_label" {
  type = string
  description = "The label for the features of the app configuration resource"
}

variable "key_vault_id" {
  type        = string
  description = "The id of the key vault resource"
}
