# App Service Domain
# REST API reference: https://docs.microsoft.com/en-us/rest/api/appservice/domains/createorupdate
resource "azapi_resource" "appservice_domain" {
  type                      = "Microsoft.DomainRegistration/domains@2022-09-01"
  name                      = var.custom_domain_name
  parent_id                 = var.resource_group_id
  location                  = "global"
  schema_validation_enabled = true

  body = jsonencode({

    properties = {
      autoRenew = false
      dnsType   = "AzureDns"
      dnsZoneId = var.dns_zone_id
      privacy   = false

      consent = {
        agreementKeys = ["DNRA"]
        agreedBy      = var.agreedby_ip_v6
        agreedAt      = var.agreedat_datetime
      }

      contactAdmin = {
        nameFirst = var.contact.nameFirst
        nameLast  = var.contact.nameLast
        email     = var.contact.email
        phone     = var.contact.phone

        addressMailing = {
          address1   = var.contact.addressMailing.address1
          city       = var.contact.addressMailing.city
          state      = var.contact.addressMailing.state
          country    = var.contact.addressMailing.country
          postalCode = var.contact.addressMailing.postalCode
        }
      }

      contactRegistrant = {
        nameFirst = var.contact.nameFirst
        nameLast  = var.contact.nameLast
        email     = var.contact.email
        phone     = var.contact.phone

        addressMailing = {
          address1   = var.contact.addressMailing.address1
          city       = var.contact.addressMailing.city
          state      = var.contact.addressMailing.state
          country    = var.contact.addressMailing.country
          postalCode = var.contact.addressMailing.postalCode
        }
      }

      contactBilling = {
        nameFirst = var.contact.nameFirst
        nameLast  = var.contact.nameLast
        email     = var.contact.email
        phone     = var.contact.phone

        addressMailing = {
          address1   = var.contact.addressMailing.address1
          city       = var.contact.addressMailing.city
          state      = var.contact.addressMailing.state
          country    = var.contact.addressMailing.country
          postalCode = var.contact.addressMailing.postalCode
        }
      }

      contactTech = {
        nameFirst = var.contact.nameFirst
        nameLast  = var.contact.nameLast
        email     = var.contact.email
        phone     = var.contact.phone

        addressMailing = {
          address1   = var.contact.addressMailing.address1
          city       = var.contact.addressMailing.city
          state      = var.contact.addressMailing.state
          country    = var.contact.addressMailing.country
          postalCode = var.contact.addressMailing.postalCode
        }
      }
    }
  })
}