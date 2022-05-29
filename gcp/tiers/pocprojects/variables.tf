variable "gcp_cloud_code" {
  description = "Code for GCP resources to use when naming or labeling resources"
  type        = string
}

variable "gcp_application_code" {
  description = "Code for GCP application to use"
  type = string
  default = "value"
}
variable "gcp_env_code" {
  description = "Code for the environment to use when naming or labeling resources"
  type        = string
  default     = "poc"
}

variable "gcp_billing_account" {
  description = "Billing Account number"
  type        = string
}

variable "gc_proj_standard_apis" {
  description = "List of services that should be enabled on the GCP project"
  type        = list(string)
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

variable "network_info" {
  description = "Map of strings with Networking project and VPC info"
  type = object({
    project = string
    vpc     = string
    subnet = string
  })
}