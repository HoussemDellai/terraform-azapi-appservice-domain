module "appservice_domain" {
  source = "../." # if calling module from local machine
  # source  = "HoussemDellai/appservice-domain/azapi" # if calling module from Terraform Registry
  # version = "2.0.0"                                 # if calling module from Terraform Registry

  custom_domain_name = var.custom_domain_name
  resource_group_id  = azurerm_resource_group.rg.id
  dns_zone_id        = azurerm_dns_zone.dns_zone.id
}
