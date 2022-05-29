module "portal_bucket" {
  source = "../../../modules/google-cloud-storage"
  project_id = var.portal_project_name
  name = "${var.gcp_cloud_code}${lower(var.gcs_bucket_default_location)}-${var.gcp_gcs_code}${var.gcp_application_code}webportal-${var.gcp_environment_code}"
  labels = var.portal_gcs_bucket.gcp_labels
  location = var.gcs_bucket_default_location
  storage_class = var.portal_gcs_bucket.storage_class
  iam_members = [{
    role = "roles/storage.objectAdmin"
    member = "serviceAccount:gc-sa-prtl-uat@gc-proj-portal-uat-1035.iam.gserviceaccount.com"
  },
  {
    role   = "roles/storage.objectAdmin"
    member = "group:${var.gcp_portal_dev_grp}"
  }
  ] 
}