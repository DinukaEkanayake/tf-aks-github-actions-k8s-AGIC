resource "azurerm_public_ip" "appgw_pip" {
  name                = "${var.appgw_name}-pip"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = var.pip_allocation_method
  sku                 = var.pip_sku
}

# Create local variables for Application Gateway
locals {
  gateway_ip_configuration_name  = "${var.appgw_name}-configuration"
  frontend_port_name             = "${var.appgw_name}-feport"
  frontend_ip_configuration_name = "${var.appgw_name}-feip"
  backend_address_pool_name      = "${var.appgw_name}-beap"
  backend_http_settings_name     = "${var.appgw_name}-be-http"
  http_listener_name             = "${var.appgw_name}-http-listner"
  request_routing_rule_name      = "${var.appgw_name}-rqrt-rule"
}

resource "azurerm_application_gateway" "appgw" {
  name                = var.appgw_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  sku {
  name = var.appgtw_sku_size
  tier = var.appgtw_sku_tier
  capacity = 1
  }

  gateway_ip_configuration {
    name      = local.gateway_ip_configuration_name
    subnet_id = var.vnet_appgw_subnet_id
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.appgw_pip.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  # frontend_port {
  #   name = "httpsPort"
  #   port = 443
  # }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.backend_http_settings_name
    cookie_based_affinity  = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = local.http_listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    priority                   = 1
    http_listener_name         = local.http_listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.backend_http_settings_name
  }

  # Since this sample is creating an Application Gateway 
   # that is later managed by an Ingress Controller, there is no need 
   # to create a backend address pool (BEP). However, the BEP is still 
   # required by the resource. Therefore, "lifecycle:ignore_changes" is 
   # used to prevent TF from managing the gateway.
   lifecycle {
     ignore_changes = [
       tags,
       backend_address_pool,
       backend_http_settings,
       http_listener,
       probe,
       request_routing_rule,
     ]
   }
}

resource "azurerm_user_assigned_identity" "ingress" {
  name                = "ingressapplicationgateway-akscluster"
  resource_group_name = var.node_resource_group
  location            = var.resource_group_location
}

# Role assignments
 resource "azurerm_role_assignment" "ra1" {
   scope                = var.rg_id
   role_definition_name = "Reader"
   principal_id = azurerm_user_assigned_identity.ingress.principal_id
 }

 resource "azurerm_role_assignment" "ra2" {
   scope                = var.vnet_id
   role_definition_name = "Network Contributor"
   principal_id         = azurerm_user_assigned_identity.ingress.principal_id
 }

 resource "azurerm_role_assignment" "ra3" {
   scope                = azurerm_application_gateway.appgw.id
   role_definition_name = "Contributor"
   principal_id         = azurerm_user_assigned_identity.ingress.principal_id
 }

# resource "azurerm_network_security_group" "appgw_nsg" {
#   name                = "appgw-nsg"
#   resource_group_name = var.resource_group_name
#   location            = var.resource_group_location

#   security_rule {
#     name                       = "Allow-FrontDoor"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_address_prefix      = "AzureFrontDoor.Backend"
#     destination_address_prefix = "*"
#     destination_port_range     = "443"
#   }
# }
# Associate NSG with appgw
# resource "azurerm_network_secur" "aks_nsg_assoc" {
#   subnet_id                 = azurerm_subnet.aks_subnet.id
#   network_security_group_id = azurerm_network_security_group.aks_nsg.id
# }

