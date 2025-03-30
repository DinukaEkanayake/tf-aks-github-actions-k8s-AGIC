data "azurerm_client_config" "current" {} #Access the configuration of the AzureRM provider to get the Azure Object ID

resource "azurerm_key_vault" "keyvault" {
  name                        = "myapp-aks-keyvault"
  location                    = var.resource_group_location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  public_network_access_enabled = true #make this false later
  purge_protection_enabled    = false

  sku_name = "standard"

  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  enable_rbac_authorization = true
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Store MySQL Admin Password in Key Vault
# resource "azurerm_key_vault_secret" "mysql_admin_password" {
#   name         = "mysql-admin-password"
#   value        = var.db_pwd
#   key_vault_id = azurerm_key_vault.keyvault.id
# }

# Store MySQL Admin Login in Key Vault
resource "azurerm_key_vault_secret" "mysql_admin_login" {
  name         = "mysql-admin-login"
  value        = "mysqladmin"
  key_vault_id = azurerm_key_vault.keyvault.id
}

# Create keyvault access policies for the aks agentpool uai.
# resource "azurerm_key_vault_access_policy" "vaultaccess" {
#  key_vault_id = azurerm_key_vault.keyvault.id
#  tenant_id    = azurerm_key_vault.keyvault.tenant_id
#  object_id    = var.aks_client_identity
#  # cluster access to secrets should be read-only
#  key_permissions = ["Get"]
#  secret_permissions = ["Get"]
#  certificate_permissions = ["Get"]

#  depends_on = [ azurerm_key_vault.keyvault ]

# }

resource "azurerm_user_assigned_identity" "akvmi" {
   name                = "akv-pod-mi"
   resource_group_name = var.resource_group_name
   location            = var.resource_group_location
 }
# Grant AKS Managed Identity Permission to Access Key Vault to read metadata about the Key Vault and get the secrets
resource "azurerm_role_assignment" "pod_get_akv_secrets" {
  scope                = azurerm_key_vault.keyvault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.akvmi.principal_id
}

resource "azurerm_federated_identity_credential" "aks_fic" {
  name                = "aks-federated-identity"
  resource_group_name = var.resource_group_name
  parent_id           = azurerm_user_assigned_identity.akvmi.id
  issuer              = var.oidc_issuer_url
  subject             = "system:serviceaccount:default:workloadidentity-sa" # Matches K8s ServiceAccount namespace & name
  audience            = ["api://AzureADTokenExchange"]
}

# resource "azurerm_private_dns_zone" "akv_01" {
#   name                = "privatelink.vaultcore.azure.net"
#   resource_group_name = var.resource_group_name
# }

# resource "azurerm_private_endpoint" "akv_01" {
#   name                          = "pvep-akv"
#   resource_group_name           = var.resource_group_name
#   location                      = var.resource_group_location
#   subnet_id                     = var.vnet_akv_subnet_id
#   custom_network_interface_name = "pvep-akv-nic"
 
#   private_service_connection {
#     name                           = "prod-akv01-private-endpoint"
#     private_connection_resource_id = azurerm_key_vault.akv.id
#     is_manual_connection           = false
#     subresource_names              = ["vault"]
#   }
 
#   private_dns_zone_group {
#     name                 = azurerm_private_dns_zone.akv_01.name
#     private_dns_zone_ids = [azurerm_private_dns_zone.akv_01.id]
#   }
 
#   depends_on = [azurerm_private_dns_zone.akv_01]
# }

# resource "azurerm_private_dns_zone_virtual_network_link" "akv_01" {
#   name                  = "prod-akv"
#   private_dns_zone_name = azurerm_private_dns_zone.akv_01.name
#   virtual_network_id    = var.vnet_id
#   resource_group_name   = var.resource_group_name
# }