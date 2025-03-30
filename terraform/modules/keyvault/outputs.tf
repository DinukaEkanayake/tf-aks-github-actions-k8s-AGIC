output "key_vault_id" {
  value = azurerm_key_vault.keyvault.id
}
output "akvmi_client_id" {
  value = azurerm_user_assigned_identity.akvmi.client_id
}
output "akvmi_tenant_id" {
  value = azurerm_user_assigned_identity.akvmi.tenant_id
}
output "akspod_uami_principal_id" {
  value = azurerm_user_assigned_identity.akvmi.principal_id
}
output "akspod_uami_id" {
  value = azurerm_user_assigned_identity.akvmi.id
}