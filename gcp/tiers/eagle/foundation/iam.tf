locals {
 # gcp_dev_grp = "gc-eagle-dev-grp@cswg.com"
  gcp_dba_grp = "gc-proj-dba-grp@cswg.com"
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
}

#resource "google_project_iam_member" "gcp_dev_grp" {
#  project  = trimprefix(module.eagle_project.project_id, "projects/")
#  for_each = toset(local.gcp_dev_grp_iam_roles)
#  role     = each.value
#  member   = "group:${local.gcp_dev_grp}"
#}

resource "google_project_iam_member" "gcp_dba_grp" {
  project  = trimprefix(module.eagle_project.project_id, "projects/")
  for_each = toset(local.gcp_dba_grp_iam_roles)
  role     = each.value
  member   = "group:${local.gcp_dba_grp}"
}