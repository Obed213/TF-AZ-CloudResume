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
  source_content         = "<h1> Test Obed213 website.</h1>" # lifeCycle/excluded

  # Lifecycle block is used to ignore the fact that I manually edit the BLOB storage contents, or edit via CI/CD with GitHub Actions, which changes the MD5 hash in the TF State file.
  lifecycle {
    ignore_changes = [
      source_content,
      content_md5
    ]
  }
}


# ##########
# Azure CDN Profile
resource "azurerm_cdn_profile" "CDN1" {
  name                = "TF-CDN1"
  location            = "Global" # This should always be set to Global due to it being a CDN. Don't user variables here.
  resource_group_name = azurerm_resource_group.RG1.name
  sku                 = "Standard_Microsoft"
}

# Endpoints to be added to the Azure CDN Profile
resource "azurerm_cdn_endpoint" "CDN1-endPoint1" {
  name                          = "TF-AZ-CDN-ObedResume"
  profile_name                  = azurerm_cdn_profile.CDN1.name
  location                      = azurerm_cdn_profile.CDN1.location
  resource_group_name           = azurerm_resource_group.RG1.name
  querystring_caching_behaviour = "IgnoreQueryString"
  origin_host_header            = "tfsaresumeobed.z24.web.core.windows.net"

  origin {
    name      = "TF-CDN1-Origin"
    host_name = "tfsaresumeobed.z24.web.core.windows.net"
  }
}