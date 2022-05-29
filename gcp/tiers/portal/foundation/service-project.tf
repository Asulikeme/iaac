locals {
  gc_proj_apis = [
    "sqladmin.googleapis.com",
    "iap.googleapis.com",
    "redis.googleapis.com",
    "storage.googleapis.com",
    "dialogflow.googleapis.com",
    "geocoding-backend.googleapis.com",
    "maps-backend.googleapis.com"
  ]
}

module "portal_project" {
  source                = "../../../modules/projects"
  name                  = "${var.gcp_cloud_code}${var.gcp_project_code}${var.gcp_application_code}${var.gcp_environment_code}"
  billing_account       = var.gcp_billing_account
  random_suffix         = var.gcp_portal_project_object.gcp_random_suffix
  folder_id             = var.parent_folder
  labels                = var.gcp_portal_project_object.gcp_labels
  enforce_cis_standards = var.gcp_portal_project_object.gcp_enforce_cis_standards
  services              = "${concat(local.gc_proj_apis, var.gc_proj_standard_apis)}"
  auto_create_network   = false
}

resource "google_compute_shared_vpc_service_project" "portal_service_project" {
  service_project = trimprefix(module.portal_project.project_id, "projects/")
  host_project    = var.network_info.project
}


