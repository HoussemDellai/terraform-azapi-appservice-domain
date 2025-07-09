variable "custom_domain_name" {
  type = string
  validation {
    condition     = length(var.custom_domain_name) > 0 && (endswith(var.custom_domain_name, ".com") || endswith(var.custom_domain_name, ".net") || endswith(var.custom_domain_name, ".co.uk") || endswith(var.custom_domain_name, ".org") || endswith(var.custom_domain_name, ".nl") || endswith(var.custom_domain_name, ".in") || endswith(var.custom_domain_name, ".biz") || endswith(var.custom_domain_name, ".org.uk") || endswith(var.custom_domain_name, ".co.in"))
    error_message = "Available top level domains are: com, net, co.uk, org, nl, in, biz, org.uk, and co.in"
  }
}

variable "dns_zone_id" {
  type = string
}

variable "resource_group_id" {
  type = string
}

variable "agreedby_ip_v6" {
  type    = string
  default = "2a04:cec0:11d9:24c8:8898:3820:8631:d83"
}

variable "agreedat_datetime" {
  type    = string
  default = "2024-01-01T9:00:00.000Z"
}

variable "contact" {
  type = object({
    nameFirst = string
    nameLast  = string
    email     = string
    phone     = string
    addressMailing = object({
      address1   = string
      city       = string
      state      = string
      country    = string
      postalCode = string
    })
  })
  default = {
    nameFirst = "John"
    nameLast  = "Doe"
    email     = "john.doe@example.com"
    phone     = "+1234567890"
    addressMailing = {
      address1   = "123 Main St"
      city       = "Anytown"
      state      = "Anystate"
      country    = "US"
      postalCode = "12345"
    }
  }
}
