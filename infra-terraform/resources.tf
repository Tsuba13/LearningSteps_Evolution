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
