data "google_compute_network" "hub" {
  project = var.hub_project
  name    = var.hub_network
}

data "google_compute_network" "nonprod" {
  project = var.nonprod_project
  name    = var.nonprod_network
}

data "google_compute_network" "prod" {
  project = var.prod_project
  name    = var.prod_network
}

# Cloud DNS - Managed Zone for Hub

module "dns-forwarding-zone-hub" {
  source     = "../../modules/cloud-dns/"
  project_id = var.hub_project
  type       = "private"
  name       = var.hub_zone_name
  domain     = var.hub_zone_domain
  labels     = var.hub_zone_labels

  private_visibility_config_networks = [data.google_compute_network.hub.self_link]
}


# Cloud DNS Peering between Production and Hub

module "dns-peering-zone-prod" {
  source                             = "../../modules/cloud-dns/"
  project_id                         = var.prod_project
  type                               = "peering"
  name                               = var.prod_peering_zone_name
  domain                             = var.prod_peering_zone_domain
  private_visibility_config_networks = [data.google_compute_network.prod.self_link]
  target_network                     = data.google_compute_network.hub.self_link
  labels                             = var.prod_peering_zone_labels
}

# Cloud DNS Peering between Non-Prod and Hub

module "dns-peering-zone-nonprod" {
  source                             = "../../modules/cloud-dns/"
  project_id                         = var.nonprod_project
  type                               = "peering"
  name                               = var.nonprod_peering_zone_name
  domain                             = var.nonprod_peering_zone_domain
  private_visibility_config_networks = [data.google_compute_network.nonprod.self_link]
  target_network                     = data.google_compute_network.hub.self_link
  labels                             = var.nonprod_peering_zone_labels
}
