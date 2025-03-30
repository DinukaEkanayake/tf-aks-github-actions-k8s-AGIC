resource "azurerm_cdn_frontdoor_profile" "afd_profile" {
  name                = "afd-profile"
  resource_group_name = var.resource_group_name
  sku_name            = "Standard_AzureFrontDoor"
}
#logical grouping of one or more routes associated domain names
resource "azurerm_cdn_frontdoor_endpoint" "afd_endpoint" {
  name                     = var.afd_endpoint
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd_profile.id
}
resource "azurerm_cdn_frontdoor_origin_group" "afd_origin_group" {
  name                     = "afd-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd_profile.id
  session_affinity_enabled = false

  health_probe {
    interval_in_seconds = 30
    path                = "/"
    protocol            = "Https"
  }

  load_balancing {
    additional_latency_in_milliseconds = 0
    successful_samples_required        = 3
  }
}
resource "azurerm_cdn_frontdoor_origin" "app_gateway_origin" {
  name                           = "app-gateway-origin"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.afd_origin_group.id
  certificate_name_check_enabled = false
  host_name                      = var.appgw_ipaddress
  origin_host_header             = var.appgw_ipaddress
  priority                       = 1
  weight                         = 100
}

resource "azurerm_cdn_frontdoor_route" "afd_route" {
  name                          = "afd-route"
  cdn_frontdoor_origin_ids = [ azurerm_cdn_frontdoor_origin.app_gateway_origin.id ]
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.afd_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.afd_origin_group.id
  supported_protocols           = ["Https"]
  patterns_to_match             = ["/*"]
  forwarding_protocol           = "HttpsOnly"

  link_to_default_domain = true
}