output "custom_domain_name" {
  value = module.appservice_domain.custom_domain_name
}

output "app_service_domain_id" {
  value = module.appservice_domain.app_service_domain_id
}

output "app_service_domain_name_servers" {
  value = module.appservice_domain.app_service_domain_name_servers
}
