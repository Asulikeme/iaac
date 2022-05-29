####
## nonprod Shared VPC
#

resource "google_compute_network" "nonprod" {
  name                    = "nonprod-core-sharedvpc"
  auto_create_subnetworks = "false"
  project                 = var.nonprod_project
}

resource "google_compute_subnetwork" "nonprod" {
  name                     = "nonprod-core-subnet"
  ip_cidr_range            = var.nonprod_cidr
  network                  = google_compute_network.nonprod.self_link
  region                   = var.region
  project                  = var.nonprod_project
  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

#Non Prod PaaS subnets
resource "google_compute_subnetwork" "nonprod-paas-subnet" {
  name                     = "gcp-ue4-snet-paas-shnp-01"
  ip_cidr_range            = var.nonprod_paas_subnet
  network                  = google_compute_network.nonprod.self_link
  region                   = var.region
  project                  = var.nonprod_project
  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# Nonprod proxy subnet for internal loadbalancers
resource "google_compute_subnetwork" "nonprod-proxy-subnet" {
  provider = google-beta
  name                     = "nonprod-ilb-proxy-subnet"
  ip_cidr_range            = var.nonprod_ilb_proxy_cidr
  purpose                  = "INTERNAL_HTTPS_LOAD_BALANCER"
  role                     = "ACTIVE"
  network                  = google_compute_network.nonprod.self_link
  region                   = var.region
  project                  = var.nonprod_project
  private_ip_google_access = false
}


resource "google_compute_router" "nonprod" {
  name    = "nonprod-cloud-router"
  network = google_compute_network.nonprod.self_link
  region  = var.region
  project = var.nonprod_project
}

module "cloud-nat-nonprod" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "1.0.0"
  router     = google_compute_router.nonprod.name
  project_id = var.nonprod_project
  region     = var.region
  name       = "cloud-nat-nonprod-router"
}

resource "google_compute_global_address" "nonprod_private_ip_address" {
  provider = google-beta

  name          = "service-provider-network-private-ip-address-nonprod"
  project       = var.nonprod_project
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.nonprod.id
}

resource "google_service_networking_connection" "nonprod_private_vpc_connection" {
  provider = google-beta

  network                 = google_compute_network.nonprod.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.nonprod_private_ip_address.name]
}

####
##Non-prod GKE VPC
#

resource "google_compute_network" "nonprod-gke" {
  name                    = "gcp-gbl-svpc-gke-01"
  auto_create_subnetworks = "false"
  project                 = var.nonprod_project
}

resource "google_compute_router" "nonprod-vpc-router" {
  name    = "gcp-gbl-svpc-gke-npvr-01"
  network = google_compute_network.nonprod-gke.name
  region  = var.region
  project = var.nonprod_project
}

####
##Non-prod ISOLATED VPC
#

resource "google_compute_network" "nonprod-isolated" {
  name                    = "gcp-gbl-svpc-iso-01"
  auto_create_subnetworks = "false"
  project                 = var.nonprod_project
}

resource "google_compute_router" "nonprod-isolated-vpc-router" {
  name    = "gcp-gbl-svpc-iso-npvr-01"
  network = google_compute_network.nonprod-isolated.name
  region  = var.region
  project = var.nonprod_project
}