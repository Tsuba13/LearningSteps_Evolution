terraform {
  backend "azurerm" {
    resource_group_name  = "LSE-tf-rg"
    storage_account_name = "tfstate1348"
    container_name       = "tfstate-container"
    key                  = "LSE-tfstate"
    use_azuread_auth     = true
  }
}
