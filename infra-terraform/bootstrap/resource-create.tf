resource "azurerm_resource_group" "tfstate-rg" {
  name     = "LSE-tf-rg"
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

resource "azurerm_storage_account" "tfstate1348-tf" {
  name                     = "tfstate1348"
  resource_group_name      = azurerm_resource_group.tfstate-rg.name
  location                 = azurerm_resource_group.tfstate-rg.location
  account_tier             = "Standard"
  account_replication_type = "ZRS"

  tags = {
    created-on = timestamp()
  }

  lifecycle {
    ignore_changes = [
      tags["created-on"],
    ]
  }
}

resource "azurerm_storage_container" "tfstate-container-tf" {
  name                  = "tfstate-container"
  storage_account_id    = azurerm_storage_account.tfstate1348-tf.id
  container_access_type = "private"
}
