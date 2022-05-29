variable "gcp_cloud_code" {
  description = "Code for GCP resources to use when naming or labeling resources"
  type        = string
  default     = "gc-"
}

variable "gcp_primary_region_code"{
  description = "Code for primary region"
  type        = string
}
variable "gcp_primary_region"{
  description = "Primary region"
  type        = string
}

variable "gcp_primary_zone"{
  description = "Primary zone"
  type        = string
}


variable "gcp_dns_project" {
  description = "Project that DNS zones are in"
  type        = string
}

variable "gcp_application_code" {
  description = "Code for the application to use when naming or labeling resources"
  type        = string
  default     = "omsp-"
}

variable "gcp_dns_zone" {
  description = "DNS zone to create record in"
  type        = string
}

variable "gcp_dns_suffix" {
  description = "DNS suffix for records"
  type        = string
}

variable "gcp_environment_code" {
  description = "Code for the environment to use when naming or labeling resources"
  type        = string
}

variable "gcp_billing_account" {
  description = "(optional) describe your variable"
  type        = string 
}

variable "omsp_project_name" {
  description = "Project to build resources in"
  type        = string
}

variable "network_info" {
    description = "Map of strings with Networking project and VPC info"
    type = object({
        project = string
        vpc     = string
        subnet  = string
    })
}

variable "gcp_dtpc_code" {
  type = string
}

variable "omsp_dataproc_cluster" {
  description = "OMS Pricing dataproc cluster info"
  type = object({
    master_num_instances  = number
    master_machine_type   = string
    master_disk_size      = number
    worker_num_instances  = number
    worker_machine_type   = string
    worker_disk_size      = number
    gcp_labels            = map(string)
    index_code            = string
  })
}

variable "omsp_project_number"{
  type        = string
  description = "Project number for OMSP"
}

variable "gcp_vpc_subnet_range"{
  type = string
}