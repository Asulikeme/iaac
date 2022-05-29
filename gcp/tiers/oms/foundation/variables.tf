variable "gcp_cloud_code" {
  description = "Code for GCP resources to use when naming or labeling resources"
  type        = string
}

variable "gcp_application_code" {
  description = "Code for the application to use when naming or labeling resources"
  type        = string
  default     = "oms-"
}

variable "gcp_environment_code" {
  description = "Code for the environment to use when naming or labeling resources"
  type        = string
}

variable "gcp_billing_account" {
  description = "Billing Account number"
  type        = string
}

variable "gc_proj_standard_apis" {
  description = "List of services that should be enabled on the GCP project"
  type        = list(string)
}

variable "gcp_oms_project_object" {
  description = "Map of objects that will contain the project details to be used during creation time."
  type = object({
    gcp_random_suffix         = bool
    gcp_enforce_cis_standards = bool
    gcp_labels                = map(string)
  })
}

variable "parent_folder" {
  description = "Environment folder that the project belongs to."
  type        = string
}

variable "gcp_primary_region" {
  description = "Region to build resources in"
  type        = string
}

variable "gcp_primary_zone" {
  description = "Zone to build resources in"
  type        = string
}

variable "gcp_project_code" {
  description = "Project code string"
  type        = string
}

variable "gcp_svc_code" {
  description = "Service account string"
  type        = string
}
variable "network_info" {
  description = "Map of strings with Networking project and VPC info"
  type = object({
    project = string
    vpc     = string
    subnet = string
  })
}