###
## IAM Definitions
#
locals {
  gcp_portal_dev_grp_iam_roles = [
        "roles/monitoring.viewer",
        "roles/logging.viewer",
        "roles/storage.objectViewer"
    ]
    gcp_portal_dba_grp_iam_roles = [
        "roles/monitoring.viewer",
        "roles/logging.viewer",
        "roles/storage.objectAdmin",
        "roles/storage.admin",
        "roles/cloudsql.admin",
        "roles/redis.admin",
        "roles/serviceusage.serviceUsageConsumer"
    ]
  gcp_portal_sa_iam_roles = [
        "roles/storage.objectAdmin",
        "roles/storage.admin"
  ]
}

resource "google_project_iam_member" "gcp_portal_dev_grp" {
  project  = trimprefix(module.portal_project.project_id, "projects/")
  for_each = toset(local.gcp_portal_dev_grp_iam_roles)
  role     = each.value
  member   = "group:${var.gcp_portal_dev_grp}"
}

resource "google_project_iam_member" "gcp_portal_dba_grp" {
  project  = trimprefix(module.portal_project.project_id, "projects/")
  for_each = toset(local.gcp_portal_dba_grp_iam_roles)
  role     = each.value
  member   = "group:${var.gcp_portal_dba_grp}"
}

module "portal_service_account" {
  source = "../../../modules/service-accounts"
  project_id = trimprefix(module.portal_project.project_id, "projects/")
  names = ["${var.gcp_cloud_code}${var.gcp_svc_code}${var.gcp_application_code}${var.gcp_environment_code}"]
  display_name = "Service account for Portal project - created using Terraform"
}

# Add steps to generate key here when gcp secrets vault is set up

resource "google_project_iam_member" "gcp_portal_sa" {
  project  = trimprefix(module.portal_project.project_id, "projects/")
  for_each = toset(local.gcp_portal_sa_iam_roles)
  role     = each.value
  member   = "serviceAccount:${module.portal_service_account.email}"
}