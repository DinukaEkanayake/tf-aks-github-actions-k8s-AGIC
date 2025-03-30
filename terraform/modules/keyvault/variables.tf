variable "resource_group_name" {
  type = string
  description = "resource group name"
}

variable "resource_group_location" {
  type = string
  description = "location of resource"
}
variable "cluster_name" {
  type = string
}
variable "oidc_issuer_url" {
  type = string
}