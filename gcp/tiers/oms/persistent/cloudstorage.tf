locals{
  gcp_dba_grp = "dev_isbd_team@cswg.com"
}


module "oms_dphs_bucket" {
  source = "../../../modules/google-cloud-storage"
  project_id = var.oms_project_name
  name = "${var.gcp_cloud_code}${lower(var.gcs_bucket_default_location)}-${var.gcp_gcs_code}${var.gcp_application_code}dphs-${var.gcp_environment_code}"
  labels = var.oms_gcs_bucket.gcp_labels
  location = var.gcs_bucket_default_location
  storage_class = var.oms_gcs_bucket.storage_class
 # iam_members = [{
 #   role = "roles/storage.objectAdmin"
 #   member = "serviceAccount:${var.oms_gcs_bucket.bucket_serviceaccount}"
 # },
  #{
 #   role   = "roles/storage.objectAdmin"
 #   member = "group:${local.gcp_dba_grp}"
 # }
 # ] 
}
module "oms_csc_bucket" {
  source = "../../../modules/google-cloud-storage"
  project_id = var.oms_project_name
  name = "${var.gcp_cloud_code}${lower(var.gcs_bucket_default_location)}-${var.gcp_gcs_code}${var.gcp_application_code}csc-${var.gcp_environment_code}"
  labels = var.oms_gcs_bucket.gcp_labels
  location = var.gcs_bucket_default_location
  storage_class = var.oms_gcs_bucket.storage_class
  # iam_members = [{
  #   role = "roles/storage.objectAdmin"
  #   member = "serviceAccount:${var.oms_gcs_bucket.bucket_serviceaccount}"
  # },
  # {
  #   role   = "roles/storage.objectAdmin"
  #   member = "group:${local.gcp_dba_grp}"
  # }
  # ] 
}
module "oms_csi_bucket" {
  source = "../../../modules/google-cloud-storage"
  project_id = var.oms_project_name
  name = "${var.gcp_cloud_code}${lower(var.gcs_bucket_default_location)}-${var.gcp_gcs_code}${var.gcp_application_code}csi-${var.gcp_environment_code}"
  labels = var.oms_gcs_bucket.gcp_labels
  location = var.gcs_bucket_default_location
  storage_class = var.oms_gcs_bucket.storage_class
  versioning = false
    retention_policy = {
    is_locked = false
    retention_period = 2592000
    
  }
  # iam_members = [{
  #   role = "roles/storage.objectAdmin"
  #   member = "serviceAccount:${var.oms_gcs_bucket.bucket_serviceaccount}"
  # },
  # {
  #   role   = "roles/storage.objectAdmin"
  #   member = "group:${local.gcp_dba_grp}"
  # }
  # ] 
}