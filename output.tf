output "appservice_domain_name" {
  value = azapi_resource.appservice_domain.output.name
}

output "app_service_domain_id" {
  value = azapi_resource.appservice_domain.output.id
}

output "app_service_domain_name_servers" {
  value = azapi_resource.appservice_domain.output.properties.nameServers
}
