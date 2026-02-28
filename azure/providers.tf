terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {
     resource_group_name  = "rg-multi-cloud-fabric"
     storage_account_name = "stfabricdev2026"
     container_name       = "tfstate"
     key                  = "terraform.tfstate"
     use_azuread_auth     = true 
   }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
}