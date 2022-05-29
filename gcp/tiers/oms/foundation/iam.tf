locals {
  gcp_dev_grp = "dev_isbd_team@cswg.com"
  gcp_dev_grp_iam_roles = [
        "roles/monitoring.viewer",
        "roles/logging.viewer",
      	"roles/dataproc.viewer",
        "roles/viewer",
        "roles/storage.objectAdmin"
    ]
  gcp_dp_iam_roles = ["roles/dataproc.admin", "roles/iam.serviceAccountUser", "roles/storage.objectAdmin", "roles/storage.admin"]
  gcp_dp_networking_iam_roles = ["roles/compute.networkUser"]
  gcp_str_iam_roles = ["roles/storage.objectAdmin"]
}


resource "google_project_iam_member" "gcp_dev_grp" {
  project  = trimprefix(module.oms_project.project_id, "projects/")
  for_each = toset(local.gcp_dev_grp_iam_roles)
  role     = each.value
  member   = "group:${local.gcp_dev_grp}"
}

module "oms_dataproc_sa_account" {
  source = "../../../modules/service-accounts"
  project_id = trimprefix(module.oms_project.project_id, "projects/")
  names = ["${var.gcp_cloud_code}${var.gcp_svc_code}${var.gcp_application_code}dataproc-${var.gcp_environment_code}"]
  display_name = "dataproc Service account for oms project - created using Terraform"
}

# Add steps to generate key here when gcp secrets vault is set up
resource "google_project_iam_member" "gcp_oms_dataproc_sa" {
  project  = trimprefix(module.oms_project.project_id, "projects/")
  for_each = toset(local.gcp_dp_iam_roles)
  role     = each.value
  member   = "serviceAccount:${module.oms_dataproc_sa_account.email}"
}

resource "google_project_iam_member" "gcp_oms_dataproc_sa_networking" {
  project  = var.network_info.project
  for_each = toset(local.gcp_dp_networking_iam_roles)
  role     = each.value
  member   = "serviceAccount:${module.oms_dataproc_sa_account.email}"
}

module "oms_storage_sa_account" {
  source = "../../../modules/service-accounts"
  project_id = trimprefix(module.oms_project.project_id, "projects/")
  names = ["${var.gcp_cloud_code}${var.gcp_svc_code}${var.gcp_application_code}storage-${var.gcp_environment_code}"]
  display_name = "Storage Service account for oms project - created using Terraform"
}
resource "google_project_iam_member" "gcp_oms_storage_sa" {
  project  = trimprefix(module.oms_project.project_id, "projects/")
  for_each = toset(local.gcp_str_iam_roles)
  role     = each.value
  member   = "serviceAccount:${module.oms_storage_sa_account.email}"
}