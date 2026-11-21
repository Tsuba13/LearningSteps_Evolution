data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "ACRRepoLister" {
  scope                = azurerm_container_registry.ACR-tf.id
  role_definition_name = "Container Registry Repository Catalog Lister"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "ACRRepoReader" {
  scope                = azurerm_container_registry.ACR-tf.id
  role_definition_name = "Container Registry Repository Reader"
  principal_id         = data.azurerm_client_config.current.object_id
}
