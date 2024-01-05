output "custom_domain_name" {
  value = jsondecode(azapi_resource.appservice_domain.output).name
}

output "app_service_domain_id" {
  value = jsondecode(azapi_resource.appservice_domain.output).id
}

output "app_service_domain_name_servers" {
  value = jsondecode(azapi_resource.appservice_domain.output).properties.nameServers
}
