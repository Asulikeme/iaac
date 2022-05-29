variable "project_name" {
  description = "Project name to build resources in"
  type        = string
}

variable "project_number" {
    description = "Project number to build resources in"
  type        = string
}

variable "gcp_app_code" {
  description = "Code for application to construct names"
  type        = string
}

variable "gcp_environment_code" {
  description = "Code for environment to construct names"
  type        = string
}

variable gcp_cloud_code {
  default = "gc-"
  type    = string
}

variable gcp_svc_code {
    default = "sa-"
    type    = string
} 

variable gcp_kmek_code {
  default = "kmek-"
}

variable gcp_gke_code {
    default = "gke-"
    type    = string
}

variable gcp_primary_location_code {
    default = "ue4-"
}

variable gcp_gke_pod_code {
    default ="gkep-"
}

variable gcp_gke_services_code {
    default = "gkes-"
}

variable gcp_gke_master_code {
    default = "gkem-"
}

variable gcp_subnet_code {
    default = "snet-"
}

variable cluster{
    type = object({
      network_policy_enabled = bool
      autoscale_cpu_minimum      = number
      autoscale_cpu_maximum      = number
      autoscale_mem_minimum      = number
      autoscale_mem_maximum      = number
      labels                     = map(string)
      maintenance_days           = string
      maintenance_end            = string
      maintenance_start          = string
    })
}

variable gke_subnets {
  type = object({
      pods     = string
      services = string
      primary  = string
      master   = string
  })
}

variable gcp_node_pool_code {
    default = "k8np-"
}

variable node {
  type = object({
    machine_type        = string
    disk_size           = number
    labels              = map(string)
    tags                = list(string)
    autoscale_min_count = number
    autoscale_max_count = number
  })
}

variable "network_info" {
  description = "Map of strings with Networking project, VPC, and DNS info"
  type = object({
    project     = string
    dns_zone    = string
    dns_suffix  = string
    dns_project = string
  })
}

variable "gcp_primary_zone"{
    description = "Zone to build resources in by default"
    default     = "us-east4-c"
}

variable "gcp_primary_region"{
    description = "Region to build resources in by default"
    default     = "us-east4"
}