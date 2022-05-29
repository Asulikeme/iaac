
variable "gcp_cloud_code" {
  description = "Code for GCP resources to use when naming or labeling resources"
  type        = string
  default     = "gc-"
}

variable "gcp_application_code" {
  description = "Code for the application to use when naming or labeling resources"
  type        = string
  default     = "prtl-"
}

variable "gcp_environment_code" {
  description = "Code for the environment to use when naming or labeling resources"
  type        = string
}

variable "gcp_billing_account" {
  description = "(optional) describe your variable"
  type        = string
}

variable "gc_proj_standard_apis" {
  description = "List of services that should be enabled on the GCP project"
  type        = list(string)
}

variable "gcp_portal_project_object" {
  description = "Map of objects that will contain the project details to be used during creation time."
  type = object({
    gcp_random_suffix         = bool
    gcp_enforce_cis_standards = bool
    gcp_labels                = map(string)
  })
}

variable "gcp_portal_dev_grp"{
  description = "'Portal developer group email"
  default = "gc-portal-dev-grp@cswg.com"
}

variable "gcp_portal_dba_grp"{
  description = "'Portal dba group email"
  default = "gc-portal-dba-grp@cswg.com"
}

variable "gcp_svc_code" {
  type = string
}

variable "gcp_primary_region" {
  type = string
}

variable "network_info" {
  description = "Map of strings with Networking project and VPC info"
  type = object({
    project = string
    vpc     = string
    subnet = string
  })
}

variable "gcp_fw_rfc1918" {
  type = list(string) 
}

variable "gcp_project_code" {
  description = "Project code string"
  type        = string
}

variable "parent_folder" {
  description = "Environment folder that the project belongs to."
  type        = string
}