# # VPN to establish tunnel from Hub to NonProd.

# module "vpn_ha_nonprod" {
#   source     = "../../modules/cloud-vpn/"
#   project_id = var.hub_project
#   region     = var.region
#   network    = google_compute_network.hub.self_link
#   name       = "ha-vpn-nonprod"
#   peer_gcp_gateway = module.vpn_ha_hub_nonprod.self_link

#   router_advertise_config = {
#     groups = var.cloud_router_customroute_config.groups
#     ip_ranges = var.cloud_router_customroute_config.ip_ranges
#     mode = "CUSTOM"
#   }

#   router_asn = 64514
#   tunnels = {
#     remote-0 = {
#       bgp_peer = {
#         address = "169.254.2.1"
#         asn     = 64515
#       }
#       bgp_peer_options                = null
#       bgp_session_range               = "169.254.2.2/30"
#       ike_version                     = 2
#       vpn_gateway_interface           = 0
#       peer_external_gateway_interface = 0
#       shared_secret                   = var.shared_secret1
#     }
#     remote-1 = {
#       bgp_peer = {
#         address = "169.254.3.1"
#         asn     = 64515
#       }
#       bgp_peer_options                = null
#       bgp_session_range               = "169.254.3.2/30"
#       ike_version                     = 2
#       vpn_gateway_interface           = 1
#       peer_external_gateway_interface = 0
#       shared_secret                   = var.shared_secret2
#     }
#   }
# }

# # VPN to establish tunnel from NonProd to Hub.

# module "vpn_ha_hub_nonprod" {
#   source     = "../../modules/cloud-vpn/"
#   project_id = var.nonprod_project
#   region     = var.region
#   network    = google_compute_network.nonprod.self_link
#   name       = "ha-vpn-hub"
#   peer_gcp_gateway = module.vpn_ha_nonprod.self_link
  
#   router_advertise_config = {
#     groups = var.cloud_router_customroute_config.groups
#     ip_ranges = {"10.181.0.0/16":"private-service-connection-range"}
#     mode = "CUSTOM"
#   }


#   router_asn = 64515
#   tunnels = {
#     remote-0 = {
#       bgp_peer = {
#         address = "169.254.2.2"
#         asn     = 64514
#       }
#       bgp_peer_options                = null
#       bgp_session_range               = "169.254.2.1/30"
#       ike_version                     = 2
#       vpn_gateway_interface           = 0
#       peer_external_gateway_interface = 0
#       shared_secret                   = var.shared_secret1
#     }
#     remote-1 = {
#       bgp_peer = {
#         address = "169.254.3.2"
#         asn     = 64514
#       }
#       bgp_peer_options                = null
#       bgp_session_range               = "169.254.3.1/30"
#       ike_version                     = 2
#       vpn_gateway_interface           = 1
#       peer_external_gateway_interface = 0
#       shared_secret                   = var.shared_secret2
#     }
#   }
# }