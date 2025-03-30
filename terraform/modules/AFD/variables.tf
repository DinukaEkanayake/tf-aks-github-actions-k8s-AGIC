variable "resource_group_name" {
  type = string
  description = "resource group name"
}

variable "resource_group_location" {
  type = string
  description = "location of resource"
}

variable "appgw_ipaddress" {
  type = string
  description = "public ip address of the appgateway"
}

variable "afd_endpoint" {
  type = string
  default = "afd-endpoint"
  description = "frontdoor endpoint name"
}