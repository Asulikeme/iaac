locals {
  gcp_dev_grp = "gc-mosaic-dev-grp@cswg.com"
  gcp_dba_grp = "gc-mosaic-dba-grp@cswg.com"
  gcp_dev_grp_iam_roles = [
        "roles/monitoring.viewer",
        "roles/logging.viewer",
      	"roles/compute.viewer",
      	"roles/cloudsql.viewer"
    ]
  gcp_dba_grp_iam_roles = [
        "roles/monitoring.viewer",
        "roles/logging.viewer",
      	"roles/compute.viewer",
      	"roles/cloudsql.admin",
        "roles/serviceusage.serviceUsageConsumer"
  ]
  gcp_mosaic_sa_iam_roles = [
        "roles/storage.objectAdmin",
        "roles/storage.admin"
  ]
}

resource "google_project_iam_member" "gcp_dev_grp" {
  project  = trimprefix(module.mosaic_project.project_id, "projects/")
  for_each = toset(local.gcp_dev_grp_iam_roles)
  role     = each.value
  member   = "group:${local.gcp_dev_grp}"
}

resource "google_project_iam_member" "gcp_dba_grp" {
  project  = trimprefix(module.mosaic_project.project_id, "projects/")
  for_each = toset(local.gcp_dba_grp_iam_roles)
  role     = each.value
  member   = "group:${local.gcp_dba_grp}"
}

module "mosaic_service_account" {
  source = "../../../modules/service-accounts"
  project_id = trimprefix(module.mosaic_project.project_id, "projects/")
  names = ["${var.gcp_cloud_code}${var.gcp_svc_code}${var.gcp_application_code}${var.gcp_environment_code}"]
  display_name = "Service account for mosaic project - created using Terraform"
}

# Add steps to generate key here when gcp secrets vault is set up

resource "google_project_iam_member" "gcp_mosaic_sa" {
  project  = trimprefix(module.mosaic_project.project_id, "projects/")
  for_each = toset(local.gcp_mosaic_sa_iam_roles)
  role     = each.value
  member   = "serviceAccount:${module.mosaic_service_account.email}"
}