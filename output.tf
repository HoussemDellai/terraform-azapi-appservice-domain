output "custom_domain_name" {
  value = var.custom_domain_name
}

output "app_service_domain_id" {
  value = jsonencode(azapi_resource.appservice_domain.output).properties.id
}