# Create the Resource Group
resource "azurerm_resource_group" "fabric_rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create a Storage Account (Azure's version of S3)
resource "azurerm_storage_account" "fabric_storage" {
  name                     = "stfabricdev2026" # Must be globally unique!
  resource_group_name      = azurerm_resource_group.fabric_rg.name
  location                 = azurerm_resource_group.fabric_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "dev"
    cloud       = "azure"
  }
}

# Create a container specifically for the Terraform State file
resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.fabric_storage.id
  container_access_type = "private"
}