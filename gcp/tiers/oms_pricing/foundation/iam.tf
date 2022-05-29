locals {
  gcp_dev_grp = "dev_isbd_team@cswg.com"
  gcp_dev_grp_iam_roles = [
        "roles/monitoring.viewer",
        "roles/logging.viewer",
      	"roles/dataproc.editor",
        "roles/storage.admin",
        "roles/storage.objectAdmin"
    ]
}

resource "google_project_iam_member" "gcp_dev_grp" {
  project  = trimprefix(module.omsp_project.project_id, "projects/")
  for_each = toset(local.gcp_dev_grp_iam_roles)
  role     = each.value
  member   = "group:${local.gcp_dev_grp}"
}