# backend.tf
# Для локального тестирования используем local backend
# Для production: закомментируй этот блок и раскомментируй azurerm ниже

terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

# === PRODUCTION: Azure backend (раскомментируй при работе с облаком) ===
# terraform {
#   backend "azurerm" {
#     resource_group_name  = "rg-terraform-state"
#     storage_account_name = "stterraformstateweu"
#     container_name       = "tfstate"
#     key                  = "future2.0/terraform.tfstate"
#     use_azuread_auth     = true
#   }
# }