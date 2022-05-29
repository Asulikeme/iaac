variable "gcp_cloud_code" {
  type        = string
  description = "length upto 3 chars including the -.Cloud code will be gc- for GCP terraform"
  default     = "gc-"
}

variable "gcp_billing_account" {
  type        = string
  description = "(optional) describe your variable"
}

variable "gcp_proj_services_to_enable" {
  description = "List of services that should be enabled on the TF project"
  type        = list(string)
}

variable "gcp_networking_projects_object" {
  description = "Map of objects that will contain the project details to be used during creation time."
  type = map(object({
    gcp_random_suffix         = bool
    gcp_folder_id             = string
    gcp_enforce_cis_standards = bool
    gcp_labels                = map(string)
  }))
}

variable "region" {
  default = "us-east4"
}

variable "hub_project" {
  default = "gc-proj-nw-sh-0ad7"

}

variable "prod_project" {
  default = "gc-proj-nw-shpr-df4e"
}

variable "nonprod_project" {
  default = "gc-proj-nw-shnp-8211"
}


variable "prod_cidr" {
  default = "10.228.0.0/16"
}

variable "nonprod_cidr" {
  default = "10.229.0.0/16"
}

variable "hub_cidr" {
  default = "10.231.0.0/24"
}
