output "gcp_monitoring_projects_output" {
  value = module.monitoring_projects[*]
}