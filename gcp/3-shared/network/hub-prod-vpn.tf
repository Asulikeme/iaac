# # VPN to establish tunnel from Hub to Prod.

# module "vpn_ha_prod" {
#   source     = "../../modules/cloud-vpn/"
#   project_id = var.hub_project
#   region     = var.region
#   network    = google_compute_network.hub.self_link
#   name       = "ha-vpn-prod"
#   peer_gcp_gateway = module.vpn_ha_hub_prod.self_link
  
#   router_advertise_config = {
#     groups = var.cloud_router_customroute_config.groups
#     ip_ranges = var.cloud_router_customroute_config.ip_ranges
#     mode = "CUSTOM"
#   }
#   router_asn = 64512
#   tunnels = {
#     remote-0 = {
#       bgp_peer = {
#         address = "169.254.0.1"
#         asn     = 64513
#       }
#       bgp_peer_options                = null
#       bgp_session_range               = "169.254.0.2/30"
#       ike_version                     = 2
#       vpn_gateway_interface           = 0
#       peer_external_gateway_interface = 0
#       shared_secret                   = var.shared_secret1
#     }
#     remote-1 = {
#       bgp_peer = {
#         address = "169.254.1.1"
#         asn     = 64513
#       }
#       bgp_peer_options                = null
#       bgp_session_range               = "169.254.1.2/30"
#       ike_version                     = 2
#       vpn_gateway_interface           = 1
#       peer_external_gateway_interface = 0
#       shared_secret                   = var.shared_secret2
#     }
#   }
# }

# # VPN to establish tunnel from Prod to Hub.

# module "vpn_ha_hub_prod" {
#   source     = "../../modules/cloud-vpn/"
#   project_id = var.prod_project
#   region     = var.region
#   network    = google_compute_network.prod.self_link
#   name       = "ha-vpn-hub"
#   peer_gcp_gateway = module.vpn_ha_prod.self_link

#    router_advertise_config = {
#     groups = var.cloud_router_customroute_config.groups
#     ip_ranges = {"10.238.0.0/16":"private-service-connection-range"}
#     mode = "CUSTOM"
#   }
  
#   router_asn = 64513
#   tunnels = {
#     remote-0 = {
#       bgp_peer = {
#         address = "169.254.0.2"
#         asn     = 64512
#       }
#       bgp_peer_options                = null
#       bgp_session_range               = "169.254.0.1/30"
#       ike_version                     = 2
#       vpn_gateway_interface           = 0
#       peer_external_gateway_interface = 0
#       shared_secret                   = var.shared_secret1
#     }
#     remote-1 = {
#       bgp_peer = {
#         address = "169.254.1.2"
#         asn     = 64512
#       }
#       bgp_peer_options                = null
#       bgp_session_range               = "169.254.1.1/30"
#       ike_version                     = 2
#       vpn_gateway_interface           = 1
#       peer_external_gateway_interface = 0
#       shared_secret                   = var.shared_secret2
#     }
#   }
# }