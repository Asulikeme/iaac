locals{
  gcp_dba_grp = "gc-proj-dba-grp@cswg.com"
}


module "chatbot_bucket" {
  source = "../../../modules/google-cloud-storage"
  project_id = var.chatbot_project_name
  name = "${var.gcp_cloud_code}${lower(var.gcs_bucket_default_location)}-${var.gcp_gcs_code}${var.gcp_application_code}${var.gcp_environment_code}"
  labels = var.chatbot_gcs_bucket.gcp_labels
  location = var.gcs_bucket_default_location
  storage_class = var.chatbot_gcs_bucket.storage_class
  iam_members = [{
    role = "roles/storage.objectAdmin"
    member = "serviceAccount:${var.chatbot_gcs_bucket.bucket_serviceaccount}"
  },
  {
    role   = "roles/storage.objectAdmin"
    member = "group:${local.gcp_dba_grp}"
  }
  ] 
}