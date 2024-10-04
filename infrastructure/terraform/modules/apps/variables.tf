variable "resource_group_name" {
  type = string
}

variable "asp_plan_sku_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "location" {
  type = string
}

variable "full_name"{
  type = string
}

variable "sanitized_name"{
  type = string
}

variable "sanitized_location" {
  type = string
}

variable "app_insights_instrumentation_key" {
  type = string
}

variable "tech_talks_domain" {
  type    = string
  default = null
}

variable "key_vault_id" {
  type = string
}

variable "app_configuration_id" {
  type = string
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

# variable "front_door_resource_guid" {
#   type = string
# }