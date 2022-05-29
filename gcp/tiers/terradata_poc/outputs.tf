output "erteam_service_account" {
  value = module.erteam_service_account.service_account
}

output "td_bucket" {
  value = module.td_bucket.bucket
}

output "gcp_project" {
  value = module.gcp_project.project_id
    
  }
