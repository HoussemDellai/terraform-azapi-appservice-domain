terraform {

  required_version = ">= 1.6"

  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = ">= 2.2.0"
    }
  }
}
