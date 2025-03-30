variable "resource_group_name" {
  type = string
  description = "resource group name"
}
variable "resource_group_location" {
  type = string
  description = "location of resource"
}
variable "vnet_name" { 
  default = "aks-vnet"
}
variable "aks_subnet_name" { 
  default = "aks-subnet1" 
}
variable "appgw_subnet_name" { 
  default = "appgw-subnet" 
}
variable "mysqldb_subnet_name" {
  default = "mysqldb_subnet" 
}
variable "nsg_name" {
  default = "aks-nsg"
}
variable "node_resource_group" {
  type = string
  description = "resource id of the aks node resource group"
}