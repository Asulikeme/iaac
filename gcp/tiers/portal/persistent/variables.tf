variable "gcp_cloud_code" {
  description = "Code for GCP resources to use when naming or labeling resources"
  type        = string
  default     = "gc-"
}

variable "gcp_memorystore_redis_code" {
  description = "Code for Memory store instance"
  type = string
}

variable "gcp_psql_code" {
  description = "Code for Postgres instance"
  type        = string
}

variable "gcp_gcs_code" {
  description = "Code for GCS code"
  type = string
}
variable "gcp_primary_region" {
  description = "Region to build resources in"
  type        = string
}

variable "gcp_primary_region_code"{
  description = "Code for primary region"
  type        = string
}
variable "gcp_primary_zone"{
  description = "Primary zone"
  type        = string
}

variable "gcp_dns_project" {
  description = "Project that DNS zones are in"
  type = string
}

variable "gcp_portal_dev_grp"{
  description = "'Portal developer group email"
  default = "gc-portal-dev-grp@cswg.com"
}

variable "gcp_application_code" {
  description = "Code for the application to use when naming or labeling resources"
  type        = string
  default     = "prtl-"
}

variable "portal_project_name" {
  description = "Name of portal project"
  type        = string
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

variable "network_info" {
    description = "Map of strings with Networking project and VPC info"
    type = object({
        project = string
        vpc     = string
        subnet = string
    })
}

variable "portal_sql_instance" {
    description = "Map of objects that will contain Timeline instance info"
    type = object({
        availability_type   = string
        tier                = string
        size                = string
        gcp_labels          = map(string)
        index_code          = string
    })
}

variable "portal_redis_instance" {
    description = "Map of objects that will contain Timeline instance info"
    type = object({
        tier                = string
        size                = string
        gcp_labels          = map(string)
        index_code          = string
    })
}

variable "portal_gcs_bucket" {
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