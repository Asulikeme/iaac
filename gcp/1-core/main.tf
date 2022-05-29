# The script will setup the platform with the core components thagt will be needed for future development and use:

# 2. Create an IAC project 
# 3. Create a service account in the IAC project for TF to use.
# 4. Assgn org level permissions, billing account user to the TF service account
# 5. Create a GCS bucket to store the TF state and assign storage admin permissions on the GCS bucket to the TF service account

locals {
  
  gcp_resource_location_code = "ue4-"
  gcp_gcs_resource_code = "gcs-"
  gcp_gcs_num_suffix = ""
  # Note about label keys and values: 
  #   The key must start with a lowercase character, 
  #   can only contain lowercase letters, numeric characters, underscores and dashes. 
  #   The key can be at most 63 characters long.
  gcp_gcs_terraform_labels = {
    org = "cswg",
    env = "prod",
    cost-center = "is310"
  }

  gcp_project_resource_code = "proj-"
  gcp_project_terraform_labels = {
    org = "cswg",
    env = "prod",
    cost-center = "is310"
  }

  gcp_svc_acc_resource_code = "sa-"
  gcp_app_code = "tf-"
  gcp_env_code = "pr"

}


# 2. Create an IAC project - we create a project under the "core" folder, so, create that first

module "core_folder" {
  source = "../modules/folders"
  parent = var.gcp_organization_id

  names = [
      "core"
    ]
  set_roles = false
}

#module "terraform_project" {
#  source = "../modules/projects"
#  name = "${var.gcp_cloud_code}${local.gcp_project_resource_code}${local.gcp_app_code}${local.gcp_env_code}"
#  billing_account = var.gcp_billing_account
#  random_suffix = true 
#  folder_id = module.core_folder.id
#  labels = local.gcp_project_terraform_labels
#  enforce_cis_standards = true
#  services = var.gcp_proj_services_to_enable
#  auto_create_network = true
#}

# 3. Create a service account in the Terraform project:
# module "terraform_service_account" {
#   source = "../modules/service-accounts"
#   project_id = trimprefix(module.terraform_project.project_id,"projects/")
#   names = ["${var.gcp_cloud_code}${local.gcp_svc_acc_resource_code}${local.gcp_app_code}${local.gcp_env_code}"]
#   display_name = "Service account for Terraform - created using Terraform"
#   project_roles = [
#     "${trimprefix(module.terraform_project.project_id,"projects/")}=>roles/owner"
#   ]
# }
/*
# Make the tf svc account the project owner for the tf project
# This could produce an error when "additive" mode is in effect, workarounds are documented at:
# https://github.com/terraform-google-modules/terraform-google-iam/issues/111
module "terraform_sa_project_iam" {
  source = "../modules/iam/projects_iam"
  projects = [trimprefix(module.terraform_project.project_id,"projects/")]
  mode = "additive"

  bindings = {
    "roles/owner" = [
      "${module.terraform_service_account.iam_email}", "group:$"
    ]
  }
}
*/

# 4. Assign org level roles for the tf service account
# resource "google_organization_iam_member" "tf_sa_org_perms" {
#   for_each = toset(var.gcp_tf_svc_acc_org_iam_roles)

#   org_id = trimprefix(var.gcp_organization_id, "organizations/")
#   role   = each.value
#   member = module.terraform_service_account.iam_email
# }

# 5. Create a GCS bucket to store the TF state and assign storage admin permissions on the GCS bucket to the TF service account 
# module "terraform_bucket" {
#   source = "../modules/google-cloud-storage"
#   count = 1
#   project_id = trimprefix(module.terraform_project.project_id, "projects/")
#   name = "${var.gcp_cloud_code}${local.gcp_resource_location_code}${local.gcp_gcs_resource_code}${local.gcp_app_code}${local.gcp_env_code}-${count.index + 1}"
#   location = "US"
#   iam_members = [{
#     role = "roles/storage.objectAdmin"
#     member = module.terraform_service_account.iam_email
#   }]
#   labels = local.gcp_gcs_terraform_labels
# }


