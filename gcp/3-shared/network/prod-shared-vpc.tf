# ####
# ## prod Shared VPC
# #

# resource "google_compute_network" "prod" {
#   name                    = "prod-core-sharedvpc"
#   auto_create_subnetworks = "false"
#   project                 = var.prod_project
# }

# resource "google_compute_subnetwork" "prod" {
#   name                     = "prod-core-subnet"
#   ip_cidr_range            = var.prod_cidr
#   network                  = google_compute_network.prod.self_link
#   region                   = var.region
#   project                  = var.prod_project
#   private_ip_google_access = true

#   log_config {
#     aggregation_interval = "INTERVAL_10_MIN"
#     flow_sampling        = 0.5
#     metadata             = "INCLUDE_ALL_METADATA"
#   }
# }

# #Prod PaaS subnet
# resource "google_compute_subnetwork" "prod-paas-subnet" {
#   name                     = "gcp-prod-paas-subnet-01"
#   ip_cidr_range            = var.prod_paas_subnet
#   network                  = google_compute_network.prod.self_link
#   region                   = var.region
#   project                  = var.prod_project
#   private_ip_google_access = true

#   log_config {
#     aggregation_interval = "INTERVAL_10_MIN"
#     flow_sampling        = 0.5
#     metadata             = "INCLUDE_ALL_METADATA"
#   }
# }

# # Prod proxy subnet for internal loadbalancers
# resource "google_compute_subnetwork" "prod-proxy-subnet" {
#   provider                 = google-beta
#   name                     = "prod-ilb-proxy-subnet-01"
#   ip_cidr_range            = var.prod_ilb_proxy_cidr
#   purpose                  = "INTERNAL_HTTPS_LOAD_BALANCER"
#   role                     = "ACTIVE"
#   network                  = google_compute_network.prod.self_link
#   region                   = var.region
#   project                  = var.prod_project
#   private_ip_google_access = false


# }
# resource "google_compute_router" "prod" {
#   name    = "prod-cloud-router"
#   network = google_compute_network.prod.self_link
#   region  = var.region
#   project = var.prod_project
# }

# module "cloud-nat-prod" {
#   source     = "terraform-google-modules/cloud-nat/google"
#   version    = "1.0.0"
#   router     = google_compute_router.prod.name
#   project_id = var.prod_project
#   region     = var.region
#   name       = "cloud-nat-prod-router"
# }

# resource "google_compute_global_address" "prod_private_ip_address" {
#   provider = google-beta

#   name          = "service-provider-network-private-ip-address-prod"
#   project       = var.prod_project
#   purpose       = "VPC_PEERING"
#   address_type  = "INTERNAL"
#   prefix_length = 16
#   network       = google_compute_network.prod.id
# }

# resource "google_service_networking_connection" "prod_private_vpc_connection" {
#   provider = google-beta

#   network                 = google_compute_network.prod.id
#   service                 = "servicenetworking.googleapis.com"
#   reserved_peering_ranges = [google_compute_global_address.prod_private_ip_address.name]
# }



# ####
# ##Prod GKE VPC
# #

# resource "google_compute_network" "prod-gke" {
#   name                    = "gc-gbl-svpc-gke-shpr-01"
#   auto_create_subnetworks = "false"
#   project                 = var.prod_project
# }

# resource "google_compute_router" "prod-vpc-router" {
#   name    = "gc-ue4-crt-gke-shpr-01"
#   network = google_compute_network.prod-gke.name
#   region  = var.region
#   project = var.prod_project
# }

# ####
# ##Prod ISOLATED VPC
# #

# resource "google_compute_network" "prod-isolated" {
#   name                    = "gc-gbl-svpc-iso-shpr-01"
#   auto_create_subnetworks = "false"
#   project                 = var.prod_project
# }

# resource "google_compute_router" "prod-isolated-vpc-router" {
#   name    = "gc-ue4-crt-iso-shpr-01"
#   network = google_compute_network.prod-isolated.name
#   region  = var.region
#   project = var.prod_project
# }