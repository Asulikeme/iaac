variable "gcp_billing_account" {
  type        = string
  description = "(optional) describe your variable"
}

variable "gcp_proj_services_to_enable" {
  description = "List of services that should be enabled on the TF project"
  type        = list(string)
}

variable "gcp_monitoring_projects_object" {
  description = "Map of objects that will contain the project details to be used during creation time."
  type = map(object({
    gcp_random_suffix         = bool
    gcp_folder_id             = string
    gcp_enforce_cis_standards = bool
    gcp_labels                = map(string)
  }))
}
