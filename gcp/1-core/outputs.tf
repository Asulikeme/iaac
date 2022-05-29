#output "gcp_terraform_project_id" {
#  value = module.terraform_project.project_id
#}

output "gcp_core_folder_id" {
  value = module.core_folder.id
}

# output "gcp_org_cloud_identity_groups" {
#   value = data.google_cloud_identity_groups.groups[*].display_name
# }

# output "gcp_terraform_service_account_email" {
#   value = module.terraform_service_account.email
# }

# output "gcp_terraform_bucket" {
#   value = module.terraform_bucket[*].bucket
# }
