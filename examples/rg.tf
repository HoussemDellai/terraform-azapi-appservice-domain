resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.custom_domain_name}"
  location = "westeurope"
}