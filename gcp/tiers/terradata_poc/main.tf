locals {
  gcp_environment_code_dash = "${var.gcp_environment_code}-"
  gcp_group_gcp_test = "gcp_test@cswg.com"
  gcp_proj_gcp_test_iam_roles = [
        "roles/monitoring.viewer",
        "roles/logging.viewer",
        "roles/bigquery.admin",
        "roles/composer.admin",
        "roles/dataflow.admin",
        "roles/pubsub.admin",
        "roles/storage.objectAdmin",
        "roles/storage.admin"
    ]
}

# Create Google Project based on inputs
module "gcp_project" {
  source                = "../../modules/projects"
  name                  = "${var.gcp_cloud_code}${var.gcp_project_code}${var.gcp_application_code}${var.gcp_environment_code}"
  billing_account       = var.gcp_billing_account
  random_suffix         = var.gcp_project_object.gcp_random_suffix
  folder_id             = var.gcp_project_object.gcp_folder_id
  labels                = var.gcp_project_object.gcp_labels
  enforce_cis_standards = var.gcp_project_object.gcp_enforce_cis_standards
  services              = var.gcp_proj_services_to_enable
  auto_create_network   = false
}

# Create Shared VPC between previously project and Shared networking project
resource "google_compute_shared_vpc_service_project" "shared_vpc" {
  host_project    = var.network_info.project
  service_project = trimprefix(module.gcp_project.project_id, "projects/")
}

resource "google_project_iam_member" "gcp_test" {
  project  = trimprefix(module.gcp_project.project_id, "projects/")
  for_each = toset(local.gcp_proj_gcp_test_iam_roles)
  role     = each.value
  member   = "group:${local.gcp_group_gcp_test}"
}


# Create service account for using bucket
module "erteam_service_account" {
  source = "../../modules/service-accounts"
  project_id = trimprefix(module.gcp_project.project_id, "projects/")
  names = ["${var.gcp_cloud_code}${var.gcp_svc_code}${var.gcp_application_code}${var.gcp_environment_code}"]
  display_name = "Service account for enterprise reporting team for Terradata bucket - created using Terraform"
}

resource "google_service_account_key" "erteam_key" {
  provider = google-beta 
  service_account_id = trimprefix(module.erteam_service_account.iam_email, "serviceAccount:")
}

# Create bucket
module "td_bucket" {
  source = "../../modules/google-cloud-storage"
  project_id = trimprefix(module.gcp_project.project_id, "projects/")
  name = "${var.gcp_cloud_code}${var.gcp_region_code}${var.gcp_gcs_code}${var.gcp_application_code}${local.gcp_environment_code_dash}${var.cloud_storage_bucket.index_code}"
  labels = var.cloud_storage_bucket.gcp_labels
  location = "US"
  storage_class = "STANDARD"
  iam_members = [{
    role = "roles/storage.objectAdmin"
    member = "${module.erteam_service_account.iam_email}"
  }
  ] 
}

# Testing fusion instance
resource "google_data_fusion_instance" "fusion_instance" {
  provider = google-beta
  project = "gc-proj-gda-dv-ae7d"
  name = "gc-ue4-dtfn-gda-dev01"
  description = "Test DataFusion instance for GDA project"
  region = "us-east4"
  type = "BASIC"
  enable_stackdriver_logging = true
  enable_stackdriver_monitoring = true
  private_instance = true
  network_config {
    network = " projects/gc-proj-nw-shnp-8211/global/networks/nonprod-core-sharedvpc"
    ip_allocation = "10.181.200.0/22"
  }
  version = "6.3.0"
  dataproc_service_account = "gc-sa-gda-dv@gc-proj-gda-dv-ae7d.iam.gserviceaccount.com"
}

resource "google_data_fusion_instance" "fusion_instance_2" {
  provider = google-beta
  project = "gc-proj-gda-dv-ae7d"
  name = "gc-ue4-dtfn-etl-dev01"
  description = "Test DataFusion instance for GDA project - ETL POC"
  region = "us-east4"
  type = "BASIC"
  enable_stackdriver_logging = true
  enable_stackdriver_monitoring = true
  private_instance = true
  network_config {
    network = " projects/gc-proj-nw-shnp-8211/global/networks/nonprod-core-sharedvpc"
    ip_allocation = "10.181.200.0/22"
  }
  version = "6.3.0"
  dataproc_service_account = "gc-sa-gda-dv@gc-proj-gda-dv-ae7d.iam.gserviceaccount.com"
}