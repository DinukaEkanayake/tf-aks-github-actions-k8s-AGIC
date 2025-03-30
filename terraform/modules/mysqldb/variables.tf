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
  description = "kubernetes cluster name"
}
variable "db_subnet_id" {
  type = string
  description = "subnet id of the db subnet from networking module"
}
variable "db_vnet_id" {
  type = string
  description = "vnet id of the db vnet"
}
