data "azurerm_policy_definition" "RGLocationMatch" {
  name = "0a914e76-4921-4c19-b460-a2d36003525a"
}

resource "azurerm_resource_group_policy_assignment" "RGLocationMatch" {
  name                 = "RGLocationMatch"
  display_name         = "Enforce Same Location as Resource Group"
  description          = "Ensure all resources that are created have the same Azure region as the resource group they are being created in."
  resource_group_id    = azurerm_resource_group.LSE-rg.id
  policy_definition_id = data.azurerm_policy_definition.RGLocationMatch.id

  parameters = jsonencode({
    effect = {
      value = "Deny"
    }
  })
}

resource "azapi_resource" "RGLocationMatchPolicyExemption" {
  type      = "Microsoft.Authorization/policyExemptions@2026-01-01-preview"
  name      = "RGLocMatchExemption"
  parent_id = azurerm_resource_group.LSE-rg.id

  body = {
    properties = {
      displayName       = "Resource Group Location Matching Policy Exemption"
      description       = "Allow resources to be created without having to match their location to the location of the resource group they're being created in."
      exemptionCategory = "Waiver"

      policyAssignmentId = azurerm_resource_group_policy_assignment.RGLocationMatch.id

      resourceSelectors = [{
        name = "WestEuropePostgresDeployment"
        selectors = [
          {
            kind = "userPrincipalId"
            in   = [var.ExemptPrincipalObjectID]
          },
          {
            kind = "resourceLocation"
            in   = ["westeurope"]
          },
          {
            kind = "resourceType"
            in = [
              "Microsoft.Network/virtualNetworks",
              "Microsoft.DBforPostgreSQL/flexibleServers",
              "Microsoft.ContainerService/managedClusters",
            ]
          },
        ]
      }]
    }
  }
}
