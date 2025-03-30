terraform {
  required_version = ">=1.9.0" #Ensures that Terraform version 1.9.0 or later is used
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm" #download the azurerm provider from HashiCorp’s official registry.
      version = "~>4.0"             #Use any version starting from 3.0.0 up to (but not including) 4.0.0
    }
  }
}

provider "azurerm" {
  features { #placeholder for any optional settings like enabling specific Azure services or behaviors in Terraform
  }
  subscription_id = "a4b91c1e-c84e-4db5-a121-73a7b6e7ee91"
}

provider "kubernetes" {
  # host                   = jsondecode(module.aks-cluster.kube_config).host
  # client_certificate     = base64decode(module.aks-cluster.kube_config.client_certificate)
  # client_key             = base64decode(module.aks-cluster.kube_config)
  # cluster_ca_certificate = base64decode(module.aks-cluster.kube_config.cluster_ca_certificate)
  #load_config_file       = false
}

provider "helm" {
 kubernetes {
   host                   = module.aks-cluster.kube_config.host
   client_certificate     = base64decode(module.aks-cluster.kube_config.client_certificate)
   client_key             = base64decode(module.aks-cluster.kube_config.client_key)
   cluster_ca_certificate = base64decode(module.aks-cluster.kube_config.cluster_ca_certificate)
 }
}