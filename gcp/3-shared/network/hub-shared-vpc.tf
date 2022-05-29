# ####
# ## Hub Core Shared VPC
# #

# resource "google_compute_network" "hub" {
#   name                    = "hub-core-sharedvpc"
#   auto_create_subnetworks = "false"
#   project                 = var.hub_project
# }

# resource "google_compute_subnetwork" "hub" {
#   name                     = "hub-core-subnet"
#   ip_cidr_range            = var.hub_cidr
#   network                  = google_compute_network.hub.self_link
#   region                   = var.region
#   project                  = var.hub_project
#   private_ip_google_access = true

#   log_config {
#     aggregation_interval = "INTERVAL_10_MIN"
#     flow_sampling        = 0.5
#     metadata             = "INCLUDE_ALL_METADATA"
#   }
# }

# resource "google_compute_router" "hub" {
#   name    = "hub-cloud-router"
#   network = google_compute_network.hub.self_link
#   region  = var.region
#   project = var.hub_project
# }

# module "cloud-hub-nat" {
#   source     = "terraform-google-modules/cloud-nat/google"
#   version    = "1.0.0"
#   router     = google_compute_router.hub.name
#   project_id = var.hub_project
#   region     = var.region
#   name       = "cloud-nat-lb-http-router"
# }

# ####
# ## Hub MGMT Shared VPC
# #

# resource "google_compute_network" "hub-mgmt" {
#   name                    = "gc-gbl-svpc-mgmt-sh-01"
#   auto_create_subnetworks = "false"
#   project                 = var.hub_project
# }

# resource "google_compute_subnetwork" "hub-mgmt-subnet" {
#   name                     = "gc-ue4-snet-mgmt-sh-01"
#   ip_cidr_range            = var.hub_mgmt_subnet
#   network                  = google_compute_network.hub-mgmt.name
#   region                   = var.region
#   project                  = var.hub_project
#   private_ip_google_access = true

#   log_config {
#     aggregation_interval = "INTERVAL_10_MIN"
#     flow_sampling        = 0.5
#     metadata             = "INCLUDE_ALL_METADATA"
#   }
# }


# ####
# ## Hub WAN Shared VPC
# #

# resource "google_compute_network" "hub-wan" {
#   name                    = "gc-gbl-svpc-wan-sh-01"
#   auto_create_subnetworks = "false"
#   project                 = var.hub_project
# }

# resource "google_compute_subnetwork" "hub-wan-subnet" {
#   name                     = "gc-ue4-snet-wan-sh-01"
#   ip_cidr_range            = var.hub_wan_subnet
#   network                  = google_compute_network.hub-wan.name
#   region                   = var.region
#   project                  = var.hub_project
#   private_ip_google_access = true

#   log_config {
#     aggregation_interval = "INTERVAL_10_MIN"
#     flow_sampling        = 0.5
#     metadata             = "INCLUDE_ALL_METADATA"
#   }
# }
