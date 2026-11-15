data "azurerm_policy_definition" "RGLocationMatch" {
	name = "0a914e76-4921-4c19-b460-a2d36003525a"
}

resource "azurerm_resource_group_policy_assignment" "RGLocationMatch" {
	name = "RGLocationMatch"
	display_name = "Enforce Same Location as Resource Group"
	description = "Ensure all resources that are created have the same Azure region as the resource group they are being created in."
	resource_group_id = azurerm_resource_group.LSE-rg.id
	policy_definition_id = data.azurerm_policy_definition.RGLocationMatch.id

	parameters = jsonencode({
		effect = {
			value = "Deny"
		}
	})
}

data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "ACRRepoLister" {
	scope = azurerm_container_registry.ACR-tf.id
	role_definition_name = "Container Registry Repository Catalog Lister"
	principal_id = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "ACRRepoReader" {
	scope = azurerm_container_registry.ACR-tf.id
    role_definition_name = "Container Registry Repository Reader"
	principal_id = data.azurerm_client_config.current.object_id
}
