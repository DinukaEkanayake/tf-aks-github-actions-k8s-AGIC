resource "azurerm_user_assigned_identity" "aks" {
   name                = "aks-${var.cluster_name}"
   resource_group_name = var.resource_group_name
   location            = var.resource_group_location
 }

# Assign Network Contributor Role to the AKS Managed Identity
resource "azurerm_role_assignment" "network_contributor" {
  scope                = var.vnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name = var.cluster_name
  location = var.resource_group_location
  resource_group_name = var.resource_group_name
  kubernetes_version = var.kubernetes_version
  role_based_access_control_enabled = true
  dns_prefix          = var.dns_prefix #Used for creating the default DNS name of the Kubernetes API server.
  oidc_issuer_enabled = true # Enable OIDC for ServiceAccount Token integration
  sku_tier = "Free"
  workload_identity_enabled = true

  automatic_upgrade_channel = "stable"  # ✅ Enables control plane auto-upgrades to stable kubernetes versions

  default_node_pool {
    name       = var.default_node_pool_name
    temporary_name_for_rotation = "newnodepool" # Required to apply changes
    node_count =  var.node_count
    vm_size    = var.default_node_pool_vm_size
    # os_disk_size_gb = 30
    # zones = ["1"]
    # type = "VirtualMachineScaleSets" #Uses VMSS (Virtual Machine Scale Sets) for auto-scaling.
    # auto_scaling_enabled = true
    vnet_subnet_id = var.vnet_aks_subnet_id
    # max_count = 5
    # min_count = 2
    max_pods = 100

    # os_upgrade_schedule {
    #   frequency     = "Weekly"    # Options: "Daily", "Weekly"
    #   interval      = 1           # Number of days/weeks between upgrades
    #   duration      = 4           # Duration (hours) to apply upgrades
    #   day_of_week   = "Sunday"  # Required if frequency is "Weekly"
    #   start_time    = "00:00"     # UTC Time for upgrade to start
    # }
  }


  # linux_profile {
  #   admin_username = var.admin_username

  #   ssh_key {
  #     key_data = 
  #   }
  # }
  
  #allows AKS cluster to securely interact with Azure resources using managed identity.
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }

  # Enable AGIC with existing App Gateway
  ingress_application_gateway {
    gateway_id = var.appgw_id
  }

 # enable CSI driver to access key vault
 key_vault_secrets_provider {
   # update the secrets on a regular basis
   secret_rotation_enabled = true
 }

  #Configure Azure CNI Plugin - Allows Kubernetes pods to get IPs from the VNet
  network_profile {
    load_balancer_sku = "standard"  #Uses the Standard Load Balancer for high availability
    network_plugin    = var.network_plugin  #Uses the Azure CNI (Container Network Interface) for better integration with Azure VNet.
    network_policy    = var.network_policy
    service_cidr       = var.network_service_cidr
    dns_service_ip     = var.network_dns_service_ip   # Must be within service_cidr range
    
  }

  #link to the Log Analytics Workspace for log collection and monitoring
  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  tags = {
    environment = "dev"
  }

  depends_on = [azurerm_role_assignment.network_contributor]

}