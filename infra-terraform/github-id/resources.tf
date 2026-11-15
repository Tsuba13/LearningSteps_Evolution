resource "azuread_application_registration" "GHEntraAppReg" {
  display_name     = "GitHubActionAppReg"
  description      = "This is the application registration that GitHub Actions will impersonate, in order to gain access the Azure Container Registry and push container images."
  sign_in_audience = "AzureADMyOrg"
}

resource "azuread_service_principal" "GHEntraSP" {
  client_id                    = azuread_application_registration.GHEntraAppReg.client_id
  app_role_assignment_required = false
}

resource "azuread_application_federated_identity_credential" "GHAppRegCreds" {
  application_id = azuread_application_registration.GHEntraAppReg.id
  display_name   = "GitHubActionsCredentials"
  description    = "OIDC federated credentials for establishing trust with GitHub Action workflows"

  # standard values for gh actions:
  issuer    = "https://token.actions.githubusercontent.com"
  audiences = ["api://AzureADTokenExchange"]

  # the subject that defines which gh branch to use
  subject = "repo:Tsuba13@25803745/LearningSteps_Evolution@1458975620:ref:refs/heads/master"
}

data "azurerm_container_registry" "ACR-tf" {
  name                = "lsevo1348acr"
  resource_group_name = "LSEvo-rg"
}

resource "azurerm_role_assignment" "ContainerWriterRole" {
  scope                = data.azurerm_container_registry.ACR-tf.id
  role_definition_name = "Container Registry Repository Writer"
  principal_id         = azuread_service_principal.GHEntraSP.object_id
}
