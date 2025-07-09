# Azure App Service Domain module for Terraform

## Problem

You can create a custom domain name in Azure using the `App Service Domain` service, either through the Azure Portal or the Azure CLI. However, this capability is not yet supported in the Azure Terraform provider.

For most enterprises, managing domain names through Infrastructure as Code (IaC) tools like `Terraform` may not be a priority. Domains are typically purchased manually, as it's a one-time task that doesn't benefit much from automation.

That said, for labs, workshops, and demos, being able to automate domain creation can add a layer of realism and completeness to the environment. In those contexts, having this feature available would be quite valuable.

## Solution

In this implementation, we demonstrate how to create a custom domain name in Azure using Terraform, leveraging the Azure App Service Domain via the AzApi provider.

Since this capability is not yet available in the official Azure Terraform provider, we use the AzApi provider to interact directly with the Azure REST API. You can find more details about the azapi_resource here:
🔗 [AzApi Resource Documentation](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/azapi_resource)

The AzApi provider allows us to send a REST API call along with a JSON payload containing the required attributes. For reference, here is the REST API used to create or update an App Service Domain:
🔗 [App Service Domain REST API](https://learn.microsoft.com/en-us/rest/api/appservice/domains/create-or-update)

In addition to the domain creation, we also provision:

An Azure DNS Zone to manage and configure the domain.
An A record named test to validate the DNS setup and ensure everything is working as expected.
The complete Terraform configuration is available in this folder.

## Video tutorial

Here is a Youtube video explaining how this works: [https://www.youtube.com/watch?v=ptdAcsG2ROI](https://www.youtube.com/watch?v=ptdAcsG2ROI)

![](https://github.com/HoussemDellai/terraform-azapi-appservice-domain/blob/main/images/youtube.png?raw=true)

## How to use it

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.custom_domain_name}"
  location = "westeurope"
}

# DNS Zone to configure the domain name
resource "azurerm_dns_zone" "dns_zone" {
  name                = var.custom_domain_name
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
  source = "../."                                    # if calling module from local machine
  # source = "HoussemDellai/appservice-domain/azapi" # if calling module from Terraform Registry

  providers = {
    azapi = azapi
  }

  custom_domain_name = var.custom_domain_name
  resource_group_id  = azurerm_resource_group.rg.id
  dns_zone_id        = azurerm_dns_zone.dns_zone.id
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

![](https://github.com/HoussemDellai/terraform-azapi-appservice-domain/blob/main/images/resources.png?raw=true)

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

![](https://github.com/HoussemDellai/terraform-azapi-appservice-domain/blob/main/images/portal.png?raw=true)

Make sure you fill the `contact_info.json` file. It is required to create domain name. More details here: https://learn.microsoft.com/en-us/cli/azure/appservice/domain?view=azure-cli-latest#az-appservice-domain-create

```sh
az group create -n rg-dns-domain -l westeurope -o table

az appservice domain create `
   --resource-group rg-dns-domain `
   --hostname "houssem.com" `
   --contact-info=@'contact_info.json' `
   --accept-terms
```

## Important notes

You should use a `Pay-As-You-Go` azure subscription to be able to create Azure App Service Domain.
MSDN/VisualStudio and Free Azure subscriptions doesn't work.

Within the terraform config file, you can change the contact info for the contactAdmin, contactRegistrant, contactBilling and contactTech.
It worked for me when reusing the same contact !

## Module available in Terraform registry

The module is available in Terraform registry: [https://registry.terraform.io/modules/HoussemDellai/appservice-domain/azapi/latest](https://registry.terraform.io/modules/HoussemDellai/appservice-domain/azapi/latest)