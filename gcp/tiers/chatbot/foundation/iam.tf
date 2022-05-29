locals {
  gcp_dev_grp = "gc-chatbot-dev-grp@cswg.com"
  gcp_dba_grp = "gc-proj-dba-grp@cswg.com"
  gcp_dev_grp_iam_roles = [
        "roles/monitoring.viewer",
        "roles/logging.viewer",
      	"roles/compute.viewer",
      	"roles/cloudsql.viewer",
        "roles/firebase.developAdmin"
    ]
  gcp_dba_grp_iam_roles = [
        "roles/monitoring.viewer",
        "roles/logging.viewer",
      	"roles/compute.viewer",
      	"roles/cloudsql.admin",
        "roles/firebase.admin",
        "roles/serviceusage.serviceUsageConsumer",
        "roles/storage.admin"
  ]
   gcp_chatbot_sa_iam_roles = [
        "roles/storage.objectAdmin",
        "roles/storage.admin"
  ]
}

resource "google_project_iam_member" "gcp_dev_grp" {
  project  = trimprefix(module.chatbot_project.project_id, "projects/")
  for_each = toset(local.gcp_dev_grp_iam_roles)
  role     = each.value
  member   = "group:${local.gcp_dev_grp}"
}

resource "google_project_iam_member" "gcp_dba_grp" {
  project  = trimprefix(module.chatbot_project.project_id, "projects/")
  for_each = toset(local.gcp_dba_grp_iam_roles)
  role     = each.value
  member   = "group:${local.gcp_dba_grp}"
}

module "chatbot_service_account" {
  source = "../../../modules/service-accounts"
  project_id = trimprefix(module.chatbot_project.project_id, "projects/")
  names = ["${var.gcp_cloud_code}${var.gcp_svc_code}${var.gcp_application_code}${var.gcp_environment_code}"]
  display_name = "Service account for chatbot project - created using Terraform"
}

# Add steps to generate key here when gcp secrets vault is set up

resource "google_project_iam_member" "gcp_chatbot_sa" {
  project  = trimprefix(module.chatbot_project.project_id, "projects/")
  for_each = toset(local.gcp_chatbot_sa_iam_roles)
  role     = each.value
  member   = "serviceAccount:${module.chatbot_service_account.email}"
}