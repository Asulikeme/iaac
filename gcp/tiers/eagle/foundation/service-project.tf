# Example creating service project. Update APIs as appropriate
#locals {
#  gc_proj_apis = [
#    "storage.googleapis.com",
#    "cloudfunctions.googleapis.com",
#    "bigquery.googleapis.com",
#    "bigquerydatatransfer.googleapis.com"
#  ]
#}

module "eagle_project" {
  source                = "../../../modules/projects"
  name                  = "${var.gcp_cloud_code}${var.gcp_project_code}${var.gcp_application_code}${var.gcp_environment_code}"
  billing_account       = var.gcp_billing_account
  random_suffix         = var.gcp_eagle_project_object.gcp_random_suffix
  folder_id             = var.parent_folder
  labels                = var.gcp_eagle_project_object.gcp_labels
  enforce_cis_standards = var.gcp_eagle_project_object.gcp_enforce_cis_standards
  services              = "${var.gc_proj_standard_apis}"
  auto_create_network   = false
}

resource "google_compute_shared_vpc_service_project" "shared_vpc" {
  host_project    = var.network_info.project
  service_project = trimprefix(module.eagle_project.project_id, "projects/")
}
