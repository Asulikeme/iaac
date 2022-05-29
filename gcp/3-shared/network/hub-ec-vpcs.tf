# ####
# ## Hub Silverpeak Edgeconnect VPCs
# #

# resource "google_compute_network" "ecmgmt" {
#   name                    = "hub-core-ecmgmtvpc"
#   auto_create_subnetworks = "false"
#   project                 = var.hub_project
# }

# resource "google_compute_subnetwork" "ecmgmt" {
#   name                     = "hub-core-ecmgmt"
#   ip_cidr_range            = "10.228.63.16/29"
#   network                  = google_compute_network.ecmgmt.self_link
#   region                   = var.region
#   project                  = var.hub_project
#   private_ip_google_access = true

#   log_config {
#     aggregation_interval = "INTERVAL_10_MIN"
#     flow_sampling        = 0.5
#     metadata             = "INCLUDE_ALL_METADATA"
#   }
# }


# resource "google_compute_network" "eclan" {
#   name                    = "hub-core-eclanvpc"
#   auto_create_subnetworks = "false"
#   project                 = var.hub_project
# }

# resource "google_compute_subnetwork" "eclan" {
#   name                     = "hub-core-eclan"
#   ip_cidr_range            = "10.228.63.0/29"
#   network                  = google_compute_network.eclan.self_link
#   region                   = var.region
#   project                  = var.hub_project
#   private_ip_google_access = true

#   log_config {
#     aggregation_interval = "INTERVAL_10_MIN"
#     flow_sampling        = 0.5
#     metadata             = "INCLUDE_ALL_METADATA"
#   }
# }

# resource "google_compute_network" "ecwan" {
#   name                    = "hub-core-ecwanvpc"
#   auto_create_subnetworks = "false"
#   project                 = var.hub_project
# }


# resource "google_compute_subnetwork" "ecwan" {
#   name                     = "hub-core-ecwan"
#   ip_cidr_range            = "10.228.63.8/29"
#   network                  = google_compute_network.ecwan.self_link
#   region                   = var.region
#   project                  = var.hub_project
#   private_ip_google_access = true

#   log_config {
#     aggregation_interval = "INTERVAL_10_MIN"
#     flow_sampling        = 0.5
#     metadata             = "INCLUDE_ALL_METADATA"
#   }
# }