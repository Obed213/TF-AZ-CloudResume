terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.1.0"
      # Pessimistic Constraint Operator
      # Will use the latest version in v4.x, but not v5
    }
  }
}

provider "azurerm" {
  subscription_id = ""
  features {}
}


##########
# Resource Group
resource "azurerm_resource_group" "RG1" {
  name     = "RG-TF-AzureResume-Obed"
  location = "Australia Central"
}


##########
# Storage Account
resource "azurerm_storage_account" "SA1" {
  name                     = "tfsaresumeobed"
  resource_group_name      = azurerm_resource_group.RG1.name
  location                 = azurerm_resource_group.RG1.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  static_website {
    index_document = "index.html"
  }
}


##########
# Storage Blob
resource "azurerm_storage_blob" "Blob1" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.SA1.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source_content         = "<h1> Test Obed213 website.</h1>"
}
