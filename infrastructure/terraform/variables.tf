variable "NAME" {
  type        = string
  description = "The name of the customer, this should always be set as 'engie'"
}

variable "ENVIRONMENT" {
  type        = string
  description = "The environment being deployed to, e.g 'qa' or 'uat'. This can be blank for production."
}

variable "LOCATION" {
  type        = string
  description = "The location to deploy resources to, most likely always 'UK South'"
}

variable "SQL_SERVER_PASSWORD" {
  type        = string
  sensitive   = true
  description = "The admin password for SQL Server admin"
}

variable "SQL_SKU_NAME" {
  type        = string
  description = "The SKU of the SQL Server"
}

variable "ASP_PLAN_SKU_NAME" {
  type        = string
  description = "The SKU of the App Service Plan for APIs"
}

variable "ALERT_EMAIL_ADDRESS" {
  type        = string
  description = "The email address to send system alerts to"
}

variable "EVOLVE_DOMAIN" {
  type        = string
  default     = null
  description = "The subdomain of audacia.systems to create domains under. Will not be used if left blank."
}

variable "RESOURCE_GROUP_NAME" {
  type        = string
  default     = null
  description = "The name of the resource group to provision resources in."
}

variable "TECH_TALKS_DOMAIN" {
  type        = string
  default     = null
  description = "The subdomain of audacia.systems to create domains under. Will not be used if left blank."
}

variable "SQL_ADMIN_OBJECT_ID" {
  type        = string
  description = "The Object ID to be made SQL Entra Admin."
}

variable "CREATE_DNS_RECORDS" {
  type        = bool
  description = "Controls whether a DNS record should be created for the TECH_TALKS_DOMAIN"
}

variable "FRONT_DOOR_SKU_NAME" {
  type        = string
  description = "The skew of the Azure Front Door Instance"
}

variable "APP_SERVICE_VNET_ADDRESS_SPACE" {
  type        = string
  description = "The IP address space of the VNET for web apps"
}

variable "APP_SERVICE_SUBNET_ADDRESS_SPACE" {
  type        = string
  description = "The IP address space of the default subnet"
}

variable "STORAGE_ACCOUNT_NAME"{
  type        = string
  description = "Name of the main storage account for the evolve system"
}

variable "APP_CONFIGURATION_SERVICE_NAME"{
  type        = string
  description = "Name of the app configuration service for the evolve system"
}

variable "KEY_VAULT_NAME"{
  type        = string
  description = "Name of the key vault service for the evolve system"
}