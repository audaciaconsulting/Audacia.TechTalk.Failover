output "portal_api_id" {
  value = azurerm_linux_web_app.app_service_api.id
}

output "portal_api_identity_principal_id" {
  value = azurerm_linux_web_app.app_service_api.identity.0.principal_id
}

output "portal_api_identity_tenant_id" {
  value = azurerm_linux_web_app.app_service_api.identity.0.tenant_id
}

output "portal_api_staging_identity_principal_id" {
  value = azurerm_linux_web_app_slot.app_service_api_slot.identity.0.principal_id
}

output "portal_api_staging_identity_tenant_id" {
  value = azurerm_linux_web_app_slot.app_service_api_slot.identity.0.tenant_id
}

output "portal_api_hostname" {
  value = azurerm_linux_web_app.app_service_api.default_hostname
}
