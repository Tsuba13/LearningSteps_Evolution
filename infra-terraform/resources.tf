resource "azurerm_resource_group" "LSE-rg" {
  name     = "LSEvo-rg"
  location = "germanywestcentral"

  tags = {
    created-on = timestamp()
  }

  lifecycle {
    ignore_changes = [
      tags["created-on"],
    ]
  }
}

resource "azurerm_container_registry" "ACR-tf" {
  name                 = "lsevo1348acr"
  resource_group_name  = azurerm_resource_group.LSE-rg.name
  location             = azurerm_resource_group.LSE-rg.location
  sku                  = "Basic"
  admin_enabled        = false
  role_assignment_mode = "AbacRepositoryPermissions"

  tags = {
    created-on = timestamp()
  }

  lifecycle {
    ignore_changes = [
      tags["created-on"],
    ]
  }
}

resource "azurerm_virtual_network" "LSEVnet" {
  name                = "LSE-vnet"
  resource_group_name = azurerm_resource_group.LSE-rg.name
  location            = azurerm_resource_group.LSE-rg.location
  address_space       = ["10.0.0.0/16"]

  lifecycle {
    ignore_changes = [
      tags["created-on"],
    ]
  }
}

resource "azurerm_subnet" "AKSSubnet" {
  name                 = "LSE-AKS-snet"
  resource_group_name  = azurerm_resource_group.LSE-rg.name
  virtual_network_name = azurerm_virtual_network.LSEVnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "DatabaseSubnet" {
  name                 = "LSE-db-snet"
  resource_group_name  = azurerm_resource_group.LSE-rg.name
  virtual_network_name = azurerm_virtual_network.LSEVnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
