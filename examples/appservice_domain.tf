module "appservice_domain" {
  source = "../."                                    # if calling module from local machine
  # source  = "HoussemDellai/appservice-domain/azapi" # if calling module from Terraform Registry
  # version = "1.0.2"                                 # if calling module from Terraform Registry

  custom_domain_name = var.custom_domain_name
  resource_group_id  = azurerm_resource_group.rg.id
  dns_zone_id        = azurerm_dns_zone.dns_zone.id

  agreedby_ip_v6    = "2a04:cec0:11d9:24c8:8898:3820:8631:d83"
  agreedat_datetime = "2023-08-10T11:50:59.264Z"

  contact = {
    nameFirst = "FirstName"
    nameLast  = "LastName"
    email     = "youremail@email.com" # you might get verification email
    phone     = "+33.762954328"
    addressMailing = {
      address1   = "1 Microsoft Way"
      city       = "Redmond"
      state      = "WA"
      country    = "US"
      postalCode = "98052"
    }
  }
}
