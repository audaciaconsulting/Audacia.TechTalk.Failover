resource "azurerm_storage_account" "storage_account" {
  name                     = "${var.sanitized_name}st"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GZRS" 

  blob_properties {
    delete_retention_policy {
      days = 14
    }
  }

  #needs to be enabled in QA so that developers can run terraform plan
  public_network_access_enabled = true
}

# ############################
# # Images Container
# ############################
resource "azurerm_storage_container" "images_container" {
  name                  = "images"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

resource "azurerm_role_assignment" "portal_api_uksouth_blob_images_container_data_contributor" {
  scope                = azurerm_storage_container.images_container.resource_manager_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.portal_api_uksouth_principal_id
}

resource "azurerm_role_assignment" "portal_api_uksouth_staging_blob_images_container_data_contributor" {
  scope                = azurerm_storage_container.images_container.resource_manager_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.portal_api_uksouth_staging_principal_id
}

resource "azurerm_role_assignment" "portal_api_ukwest_blob_images_container_data_contributor" {
  scope                = azurerm_storage_container.images_container.resource_manager_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.portal_api_ukwest_principal_id
}

resource "azurerm_role_assignment" "portal_api_ukwest_staging_blob_images_container_data_contributor" {
  scope                = azurerm_storage_container.images_container.resource_manager_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.portal_api_ukwest_staging_principal_id
}