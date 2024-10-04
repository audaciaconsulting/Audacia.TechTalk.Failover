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

variable "node_version" {
  type        = string
  description = "The dotnetv version"
}