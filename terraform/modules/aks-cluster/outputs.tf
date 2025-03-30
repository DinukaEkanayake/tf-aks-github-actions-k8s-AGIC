#Retrieves the kubeconfig needed to connect to the AKS cluster. contains credentials for kubectl to interact with the cluster.
output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks-cluster.kube_config.0
  sensitive = true
}
output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks-cluster.kube_config[0].client_certificate
  sensitive = true
}

output "client_key" {
  value     = azurerm_kubernetes_cluster.aks-cluster.kube_config[0].client_key
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = azurerm_kubernetes_cluster.aks-cluster.kube_config[0].cluster_ca_certificate
  sensitive = true
}
output "cluster_password" {
  value     = azurerm_kubernetes_cluster.aks-cluster.kube_config[0].password
  sensitive = true
}
output "cluster_username" {
  value     = azurerm_kubernetes_cluster.aks-cluster.kube_config[0].username
  sensitive = true
}
output "host" {
  value     = azurerm_kubernetes_cluster.aks-cluster.kube_config[0].host
  sensitive = true
}
output "aks-cluster_id" {
  value = azurerm_kubernetes_cluster.aks-cluster.id
}
output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks-cluster.name
}

#Azure AD Principal ID represents the Managed Identity used by AKS to access other Azure services securely.
output "kubelet_identity_object_id" {
  value       = azurerm_kubernetes_cluster.aks-cluster.kubelet_identity.0.object_id
  description = "Specifies the object id of the kubelet identity of the AKS cluster."
}
output "kubelet_identity_client_id" {
  value       = azurerm_kubernetes_cluster.aks-cluster.kubelet_identity.0.client_id
  description = "Specifies the client id of the kubelet identity of the AKS cluster."
}
output "aks_node_resource_group" {
  value       = azurerm_kubernetes_cluster.aks-cluster.node_resource_group
  description = "Specifies the resource id of the auto-generated Resource Group which contains the resources for this Managed Kubernetes Cluster."
}

output "aks_managed_identity" {
  value = azurerm_user_assigned_identity.aks.principal_id
}

# Required to set IAM role on appgw subnet.
output "aks_uai_appgw_object_id" { 
  value = azurerm_kubernetes_cluster.aks-cluster.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
}
output "aks_oidc_issuer_url" {
  value = azurerm_kubernetes_cluster.aks-cluster.oidc_issuer_url
}
# output "aks_client_identity" {
#   value = azurerm_kubernetes_cluster.aks-cluster.key_vault_secrets_provider[0].secret_identity[0].object_id
# }

