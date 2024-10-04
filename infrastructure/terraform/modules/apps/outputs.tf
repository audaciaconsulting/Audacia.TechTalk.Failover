output "app_service_plan_id" {
  value = azurerm_service_plan.app_service_plan.id
}

## Office Portal Output
output "portal_api_hostname" {
  value = module.portal-api-web-app.portal_api_hostname
}

output "portal_ui_hostname" {
  value = module.portal-ui-web-app.portal_ui_hostname
}

output "portal_api_id" {
  value = module.portal-api-web-app.portal_api_id
}

output "portal_ui_id" {
  value = module.portal-ui-web-app.portal_ui_id
}

output "portal_api_identity_principal_id" {
  value = module.portal-api-web-app.portal_api_identity_principal_id
}

output "portal_api_identity_tenant_id" {
  value = module.portal-api-web-app.portal_api_identity_tenant_id
}

output "portal_api_staging_identity_principal_id" {
  value = module.portal-api-web-app.portal_api_staging_identity_principal_id
}

output "portal_api_staging_identity_tenant_id" {
  value = module.portal-api-web-app.portal_api_staging_identity_tenant_id
}