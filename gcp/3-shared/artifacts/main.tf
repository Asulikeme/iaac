locals {
  gcp_environment_code_dash = "${var.gcp_environment_code}-"
}

# Create Project
module "artifacts_project" {
  source                = "../../modules/projects"
  name                  = "${var.gcp_cloud_code}${var.gcp_project_code}${var.gcp_application_code}${var.gcp_environment_code}"
  billing_account       = var.gcp_billing_account
  random_suffix         = var.gcp_artifacts_project_object.gcp_random_suffix
  folder_id             = var.gcp_artifacts_project_object.gcp_folder_id
  labels                = var.gcp_artifacts_project_object.gcp_labels
  enforce_cis_standards = var.gcp_artifacts_project_object.gcp_enforce_cis_standards
  services              = var.gcp_proj_services_to_enable
  auto_create_network   = true
}

# Create Shared VPC between Artifacts project and Shared networking project
resource "google_compute_shared_vpc_service_project" "shared_vpc" {
  #host_project    = var.network_info.project
  # Temporarily, the host project will be the customer portal project, remove this after things are fixed
  host_project    = "customerportal-308515"
  service_project = trimprefix(module.artifacts_project.project_id, "projects/")
}

module "org_compute_vmExternalIpAccess_policy" {
  source = "../../modules/org-policies"
  constraint = "constraints/compute.vmExternalIpAccess"
  policy_type = "list"
  project_id   = trimprefix(module.artifacts_project.project_id, "projects/")
  enforce = false
  policy_for = "project"
}

# Create service accounts
module "packer_service_account" {
  source = "../../modules/service-accounts"
  project_id = trimprefix(module.artifacts_project.project_id, "projects/")
  names = ["${var.gcp_cloud_code}${var.gcp_svc_code}${var.gcp_application_code}${var.gcp_environment_code}"]
  display_name = "Service account for Packer - created using Terraform"
}

# Create keys for service accounts
resource "google_service_account_key" "packer_sa_key" {
  provider = google-beta
  service_account_id = module.packer_service_account.email
}