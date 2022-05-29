locals {
  gcp_dev_grp = "gc-epod-dev-grp@cswg.com"
  gcp_dev_grp_iam_roles = [
        "roles/monitoring.viewer",
        "roles/logging.viewer",
      	"roles/compute.viewer",
      	"roles/run.viewer",
        "roles/errorreporting.viewer"
    ]

  gcp_dba_grp = "gc-proj-dba-grp@cswg.com"
  gcp_dba_grp_iam_roles = [
        "roles/monitoring.viewer",
        "roles/logging.viewer",
      	"roles/compute.viewer",
      	"roles/run.admin",
        "roles/iam.serviceAccountUser",
        "roles/storage.admin",
        "roles/storage.objectAdmin",
        "roles/vpcaccess.admin"
  ]
  gcp_default_compute_sa = "${module.epod_project.project_number}-compute@developer.gserviceaccount.com"
  gcp_default_compute_sa_roles = [
        "roles/run.admin",
        "roles/iam.serviceAccountUser"
  ]

  gcp_default_robot_sa = "service-${module.epod_project.project_number}@serverless-robot-prod.iam.gserviceaccount.com"
  gcp_default_robot_sa_roles = [
    "roles/vpcaccess.user"
  ]
}

resource "google_project_iam_member" "gcp_dev_grp" {
  project  = trimprefix(module.epod_project.project_id, "projects/")
  for_each = toset(local.gcp_dev_grp_iam_roles)
  role     = each.value
  member   = "group:${local.gcp_dev_grp}"
}

resource "google_project_iam_member" "gcp_dba_grp" {
  project  = trimprefix(module.epod_project.project_id, "projects/")
  for_each = toset(local.gcp_dba_grp_iam_roles)
  role     = each.value
  member   = "group:${local.gcp_dba_grp}"
}

resource "google_project_iam_member" "gcp_default_compute_sa" {
  project  = trimprefix(module.epod_project.project_id, "projects/")
  for_each = toset(local.gcp_default_compute_sa_roles)
  role     = each.value
  member   = "serviceAccount:${local.gcp_default_compute_sa}"
}

resource "google_project_iam_member" "gcp_default_robot_sa" {
  project  = var.network_info.project
  for_each = toset(local.gcp_default_robot_sa_roles)
  role     = each.value
  member   = "serviceAccount:${local.gcp_default_robot_sa}"
}