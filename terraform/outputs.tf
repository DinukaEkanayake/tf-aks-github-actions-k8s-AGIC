output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
output "aks_cluster_name" {
   value = module.aks-cluster.aks_cluster_name
 }
output "application_gateway_name" {
   value = module.appgw.appgw_name
 }
output "application_ip_address" {
   value = module.appgw.appgw_pip
 }
output "acr_login_server" {
  value = module.acr.acr_login_server
}
output "acr_username" {
  value = module.acr.acr_username
}

output "acr_password" {
  value     = module.acr.acr_password
  sensitive = true
}

# Required to set IAM role on appgw subnet.
output "aks_uai_appgw_object_id" {
  value = module.aks-cluster.aks_uai_appgw_object_id #a9f2102f-ab80-47d2-b0ee-dfa8b6d588f3
}

output "akvmi_client_id" {
  value = module.keyvault.akvmi_client_id
}
output "akvmi_tenant_id" {
  value = module.keyvault.akvmi_tenant_id
}
output "aks_oidc_issuer_url" {
  value = module.aks-cluster.aks_oidc_issuer_url
}
output "db_username" {
  value = module.mysqldb.username
}
output "is_public_access" {
  value = module.mysqldb.is_public_access
}