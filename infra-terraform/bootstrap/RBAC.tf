data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "ContainerAssignedRole" {
  scope                = azurerm_storage_container.tfstate-container-tf.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

data "azurerm_policy_definition" "RGLocationMatch" {
	name = "0a914e76-4921-4c19-b460-a2d36003525a"
}

resource "azurerm_resource_group_policy_assignment" "RGLocationMatch" {
	name = "RGLocationMatch"
	display_name = "Enforce Same Location as Resource Group"
	description = "Ensure all resources that are created have the same Azure region as the resource group they are being created in."
	resource_group_id = azurerm_resource_group.tfstate-rg.id
	policy_definition_id = data.azurerm_policy_definition.RGLocationMatch.id

	parameters = jsonencode({
		effect = {
			value = "Deny"
		}
	})
}
