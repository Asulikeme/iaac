# The script will setup the central networking projects that will be utilized by various applications

locals {

  # Note about label keys and values: 
  #   The key must start with a lowercase character, 
  #   can only contain lowercase letters, numeric characters, underscores and dashes. 
  #   The key can be at most 63 characters long.

}

# module "networking_projects" {
#   source                = "../../modules/projects"
#   for_each              = var.gcp_networking_projects_object
#   name                  = each.key
#   billing_account       = var.gcp_billing_account
#   random_suffix         = each.value.gcp_random_suffix
#   folder_id             = each.value.gcp_folder_id
#   labels                = each.value.gcp_labels
#   enforce_cis_standards = each.value.gcp_enforce_cis_standards
#   services              = var.gcp_proj_services_to_enable
#   auto_create_network   = true
# }


# resource "google_compute_shared_vpc_host_project" "hub" {
#   project = var.hub_project
# }

resource "google_compute_shared_vpc_host_project" "prod" {
  project = var.prod_project
}

resource "google_compute_shared_vpc_host_project" "nonprod" {
  project = var.nonprod_project
}

