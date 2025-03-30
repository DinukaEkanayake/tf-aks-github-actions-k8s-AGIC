# #Azure DNS + CNAME Record
# resource "azurerm_dns_zone" "dns_zone" {
#   name                = "example.com"
#   resource_group_name = "my-dns-rg"
# }

# resource "azurerm_dns_cname_record" "afd_cname" {
#   name                = "app"
#   zone_name           = azurerm_dns_zone.dns_zone.name
#   resource_group_name = azurerm_dns_zone.dns_zone.resource_group_name
#   ttl                 = 300
#   record              = azurerm_cdn_frontdoor_endpoint.afd_endpoint.host_name
# }
# #Custom Domain + HTTPS
# resource "azurerm_cdn_frontdoor_custom_domain" "afd_custom_domain" {
#   name                     = "app-example-com"
#   cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd_profile.id
#   host_name                = "app.example.com"
#   tls {
    
#   }
# }

# resource "azurerm_cdn_frontdoor_custom_domain_association" "afd_https" {
#   cdn_frontdoor_custom_domain_id = azurerm_cdn_frontdoor_custom_domain.afd_custom_domain.id
#   cdn_frontdoor_route_ids        = [azurerm_cdn_frontdoor_route.afd_route.id]
# }

# resource "azurerm_cdn_frontdoor_custom_domain_https" "afd_enable_https" {
#   custom_domain_id    = azurerm_cdn_frontdoor_custom_domain.afd_custom_domain.id
#   certificate_type    = "ManagedCertificate"
#   minimum_tls_version = "TLS12"
# }
