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
  default     = "oms-"
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

variable "oms_project_name" {
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

variable "oms_dataproc_cluster" {
  description = "OMS Pricing dataproc cluster info"
  type = object({
    master_num_instances  = number
    master_machine_type   = string
    master_disk_size      = number
    gcp_labels            = map(string)
    index_code            = string
  })
}

variable "oms_project_number"{
  type        = string
  description = "Project number for OMS"
}

variable "gcp_vpc_subnet_range"{
  type = string
}

variable "oms_gcs_bucket" {
  description = "GCS Bucket info"
  type = object({
    storage_class    = string
    gcp_labels       = map(string)
  })
}

variable "gcs_bucket_default_location"{
  description = "Default location for buckets"
  type      = string
}

variable "gcp_gcs_code" {
  description = "Code for GCS code"
  type = string
}
