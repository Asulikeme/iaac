locals {
  gcp_devops_devs_grp = "gc-dop-devs-grp@cswg.com"
  gcp_devops_devs_grp_iam_roles = [
        "roles/monitoring.viewer",
        "roles/logging.viewer",
      	"roles/compute.admin"
    ]
}

resource "google_project_iam_member" "gcp_devops_devs_grp" {
  project  = trimprefix(module.devops_project.project_id, "projects/")
  for_each = toset(local.gcp_devops_devs_grp_iam_roles)
  role     = each.value
  member   = "group:${local.gcp_devops_devs_grp}"
}