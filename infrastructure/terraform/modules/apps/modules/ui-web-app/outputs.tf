output "portal_ui_id" {
  value = azurerm_linux_web_app.app_service_ui.id
}

output "portal_ui_identity_principal_id" {
  value = azurerm_linux_web_app.app_service_ui.identity.0.principal_id
}

output "portal_ui_identity_tenant_id" {
  value = azurerm_linux_web_app.app_service_ui.identity.0.tenant_id
}

output "portal_ui_staging_identity_principal_id" {
  value = azurerm_linux_web_app_slot.app_service_ui_slot.identity.0.principal_id
}

output "portal_ui_staging_identity_tenant_id" {
  value = azurerm_linux_web_app_slot.app_service_ui_slot.identity.0.tenant_id
}

output "portal_ui_hostname" {
  value = azurerm_linux_web_app.app_service_ui.default_hostname
}