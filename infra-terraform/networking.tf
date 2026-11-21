resource "azurerm_virtual_network" "LSEVnet" {
  name                = "LSE-vnet"
  resource_group_name = azurerm_resource_group.LSE-rg.name
  location            = var.ExemptedLocation
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
  address_prefixes     = ["10.0.2.0/28"]

  delegation {
    name = "PostgreSQLDelegation"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

resource "azurerm_private_dns_zone" "PostgresDNS" {
  name                = "LSE-PrivateDNS.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.LSE-rg.name

  lifecycle {
    ignore_changes = [
      tags["created-on"],
    ]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "PostgresDNSLink" {
  name                 = "LSE-PostgresDNSlink"
  private_dns_zone_id  = azurerm_private_dns_zone.PostgresDNS.id
  virtual_network_id   = azurerm_virtual_network.LSEVnet.id
  registration_enabled = false

  lifecycle {
    ignore_changes = [
      tags["created-on"],
    ]
  }
}
