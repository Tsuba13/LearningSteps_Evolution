resource "azurerm_postgresql_flexible_server" "PostgresServer" {
  name                = "lsevo1348postgres"
  resource_group_name = azurerm_resource_group.LSE-rg.name
  location            = var.ExemptedLocation

  # PostgreSQL server specs
  version      = "17"
  sku_name     = "B_Standard_B1ms"
  storage_mb   = 32768
  storage_type = "Premium_LRS"

  # networking
  delegated_subnet_id           = azurerm_subnet.DatabaseSubnet.id
  private_dns_zone_id           = azurerm_private_dns_zone.PostgresDNS.id
  public_network_access_enabled = false

  # authentication
  authentication {
    active_directory_auth_enabled = true
    password_auth_enabled         = false
    tenant_id                     = data.azurerm_client_config.current.tenant_id
  }

  lifecycle {
    ignore_changes = [
      tags["created-on"],
      zone,
    ]
  }
}

resource "azurerm_user_assigned_identity" "PostgresAdminManagedIdentity" {
  name                = "LSE-PGServerManagedIdentity"
  resource_group_name = azurerm_resource_group.LSE-rg.name
  location            = azurerm_resource_group.LSE-rg.location

  lifecycle {
    ignore_changes = [
      tags["created-on"],
    ]
  }
}

resource "azurerm_postgresql_flexible_server_active_directory_administrator" "PostgresAdmin" {
  server_name         = azurerm_postgresql_flexible_server.PostgresServer.name
  resource_group_name = azurerm_resource_group.LSE-rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  principal_type = "ServicePrincipal"
  principal_name = azurerm_user_assigned_identity.PostgresAdminManagedIdentity.name
  object_id      = azurerm_user_assigned_identity.PostgresAdminManagedIdentity.principal_id
}
