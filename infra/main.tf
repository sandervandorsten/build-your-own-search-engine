provider "azurerm" {
  version = "~>2.0"
  features {}
}

resource "azurerm_resource_group" "rg" {
  name = "svd_search_engine_02"
  location = var.location
}

resource "azurerm_storage_account" "storage_account" {
  account_replication_type = "LRS"
  account_tier = "Standard"
  location = var.location
  name = "svdsearchstorage01"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_storage_container" "covid_news" {
  name = "covid-news"
  storage_account_name = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

resource "azurerm_search_service" "covid_search_service" {
  name                = "covid-search-service"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "standard"
  allowed_ips         = []  // TODO: replace with Client IP in some way?
}

resource "azurerm_container_registry" "streamlit_container" {
  name                     = "svdacr01"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Standard"
  admin_enabled            = true
}

resource "azurerm_container_registry" "streamlit_container2" {
  name                     = "svdacr02"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Premium"
  admin_enabled            = true
}