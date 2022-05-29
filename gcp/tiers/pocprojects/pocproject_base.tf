
module "project" {
  source = "../../modules/projects-module"
  gcp_env_code = "poc"
  gcp_application_code = each.value.application_code
  parent_folder = var.parent_folder
  gcp_project_labels = each.value.project_labels
  gc_proj_standard_apis = each.value.standard_apis
  network_info_project = var.network_info.project
  gcp_notification_recipients = each.value.notification_recipients
  gcp_iam_permissions = each.value.iam_permission
# gcp_grp_iam_roles = each.value.iam_role
  
  for_each = {for project in local.pocprojects: project.application_code => project}


}



#"dev_isbd_team@cswg.com"
#"intelsystemsgroup@cswg.com"
#"webportalteam@cswg.com"