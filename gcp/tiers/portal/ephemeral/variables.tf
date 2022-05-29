variable "gcp_environment_code" {
  description = "Code for the environment to use when naming or labeling resources"
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


variable "portal_project_name" {
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

variable "gcp_dns_project" {
  description = "Project that DNS zones are in"
  type = string
}

variable "gcp_dns_zone" {
  description = "DNS zone to create record in"
  type        = string
}

variable "gcp_dns_suffix" {
  description = "DNS suffix for records"
  type        = string
}