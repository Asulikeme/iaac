# This block of variables can be moved to a common variables file.
variable "gcp_cloud_code" {
  description = "Code for GCP resources to use when naming or labeling resources"
  type        = string
  default     = "gc-"
}

variable "gcp_region_code" {
  description = "Code for the region to use when naming or labeling resources"
  type        = string
  default     = "ue4-"
}

variable "gcp_project_code"{
  description = "Code for the project resources"
  type        = string
  default     = "proj-"
}

variable "gcp_svc_code"{
  description = "Code for the service account resources"
  type        = string
  default     = "sa-"
}

variable "gcp_gcs_code"{
  description = "Code for the Cloud storage resources"
  type        = string
  default     = "gcs-"
}

variable "gcp_environment_code" {
  description = "Code for the environment to use when naming or labeling resources"
  type        = string
}

variable "gcp_billing_account" {
  description = "(optional) describe your variable"
  type        = string 
}

variable "gcp_proj_services_to_enable" {
  description = "List of services that should be enabled on the TF project"
  type        = list(string)
}

variable "gcp_project_object" {
  description = "Map of objects that will contain the project details to be used during creation time."
  type = object({
    gcp_random_suffix         = bool
    gcp_folder_id             = string
    gcp_enforce_cis_standards = bool
    gcp_labels                = map(string)
  })
}

variable "region" {
  description = "Region to build resources in"
  default = "us-east4"
}

variable "network_info" {
    description = "Map of strings with Networking project and VPC info"
    type = object({
        project = string
        vpc     = string
    })
}

# This variable is project specific and need to be modified after copying template
variable "gcp_application_code" {
  description = "Code for the application to use when naming or labeling resources"
  type        = string
  default     = "gda-" 
}


variable "cloud_storage_bucket" {
    description = "Map of objects that will contain bucket info"
    type = object({
        index_code = string
        gcp_labels = map(string)
    })
}
