locals {
  gcp_dba_grp = "gc-mosaic-dba-grp@cswg.com"
}

module "mosaic_bucket" {
  source = "../../../modules/google-cloud-storage"
  project_id = var.mosaic_project_name
  name = "${var.gcp_cloud_code}${lower(var.gcs_bucket_default_location)}-${var.gcp_gcs_code}${var.gcp_application_code}${var.gcp_environment_code}"
  labels = var.mosaic_gcs_bucket.gcp_labels
  location = var.gcs_bucket_default_location
  storage_class = var.mosaic_gcs_bucket.storage_class
  iam_members = [{
    role = "roles/storage.objectAdmin"
    member = "serviceAccount:${var.mosaic_gcs_bucket.service_account}"
  },
  {
    role   = "roles/storage.objectAdmin"
    member = "group:${local.gcp_dba_grp}"
  }
  ] 
}

