output "instrumentation_key" {
  value     = azurerm_application_insights.app_insights.instrumentation_key
  sensitive = true
}

output "id" {
  value     = azurerm_application_insights.app_insights.id
  sensitive = true
}

output "log_anayltics_workspace_id" {
  value = azurerm_log_analytics_workspace.log_analytics_workspace.id
}