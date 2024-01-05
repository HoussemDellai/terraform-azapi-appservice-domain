# Azure App Service Domain module for Terraform

## Problem

You can create a custom domain name in Azure using App Service Domain service.
You can do that using Azure portal or Azure CLI.
But you cannot do that using Terraform for Azure provider.
Because that is not implemented yet.
Creating a custom domain in infra as code tool like Terraform might not be that much appealing for enterprises.
They would purchase their domain name manually, just once. Infra as code doesn't make lots of sense here.

However for labs, workshops and demonstrations, this is very useful to make the lab more realistic.

## Solution

We'll provide a Terraform implementation for creating a custom domain name using Azure App Service Domain.
We'll use `AzApi` provider to create the resource. More info about AzApi here: https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/azapi_resource.

The AzApi will call the REST API and pass the required JSON file containing the needed attributes.
Take a look at the REST API for App Service Domain here: https://learn.microsoft.com/en-us/rest/api/appservice/domains/create-or-update

We also create an Azure DNS Zone to manage and configure the domain name.

And we create an A record "test" to make sure the configuration works.

The complete Terraform implementation is in this current folder.

## How to use it

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.custom_domain_name}"
  location = "westeurope"
}

# DNS Zone to configure the domain name
resource "azurerm_dns_zone" "dns_zone" {
  name                = var.domain_name
  resource_group_name = azurerm_resource_group.rg.name
}

# DNS Zone A record
resource "azurerm_dns_a_record" "dns_a_record" {
  name                = "test"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = ["1.2.3.4"] # just example IP address
}

module "appservice_domain" {
  source = "../."

  providers = {
    azapi = azapi
  }

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

variable "custom_domain_name" {
  type = string
  validation {
    condition     = length(var.custom_domain_name) > 0 && (endswith(var.custom_domain_name, ".com") || endswith(var.custom_domain_name, ".net") || endswith(var.custom_domain_name, ".co.uk") || endswith(var.custom_domain_name, ".org") || endswith(var.custom_domain_name, ".nl") || endswith(var.custom_domain_name, ".in") || endswith(var.custom_domain_name, ".biz") || endswith(var.custom_domain_name, ".org.uk") || endswith(var.custom_domain_name, ".co.in"))
    error_message = "Available top level domains are: com, net, co.uk, org, nl, in, biz, org.uk, and co.in"
  }
}
```

## Deploy the resources using Terraform

Choose the custom domain name you want to purchase in the file `terraform.tfvars`.

Then run the following Terraform commands from within the current folder.

```sh
terraform init
terraform plan -out tfplan
terraform apply tfplan
```

## Test the deployment

Verify you have two resources created within the resource group.

<img src="https://github.com/HoussemDellai/terraform-azapi-appservice-domain/blob/main/images/resources.png?raw=true">

Verify that custom domain name works.
You should see the IP address we used in A record which is `1.2.3.4`.

```sh
nslookup test.<var.domain_name> # replace with domain name
# Server:  bbox.lan
# Address:  2001:861:5e62:69c0:861e:a3ff:fea2:796c
# Non-authoritative answer:
# Name:    test.houssem13.com
# Address:  1.2.3.4
```

## Creating a custom domain name using Azure CLI

In this lab we used Terraform to create the domain name.
But still you can just use Azure portal or command line.

<img src="https://github.com/HoussemDellai/terraform-azapi-appservice-domain/blob/main/images/portal.png?raw=true">

Make sure you fill the `contact_info.json` file. It is required to create domain name.

```sh
az group create -n rg-dns-domain -l westeurope -o table

az appservice domain create `
   --resource-group rg-dns-domain `
   --hostname "houssem.com" `
   --contact-info=@'contact_info.json' `
   --accept-terms
```

## Important notes

You should use a Pay-As-You-Go azure subscription to be able to create Azure App Service Domain.
MSDN/VisualStudio and Free Azure subscriptions doesn't work.

Within the terraform config file, you can change the contact info for the contactAdmin, contactRegistrant, contactBilling and contactTech.
It worked for me when reusing the same contact !