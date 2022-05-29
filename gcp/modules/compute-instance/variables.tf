variable "project_name" {
  description = "Project to build resources in"
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

variable "gcp_xlb_code" {
  default = "xlb-"
  type    = string
}

variable "gcp_ilb_code" {
  default = "ilb-"
  type    = string
}

variable gcp_loc_global_code{
  default = "gbl-"
  type    = string
}

variable gcp_cloud_code {
  default = "gc-"
  type    = string
}

variable "compute_instances" {
  description = "Compute instance variables"
  type = object({
    count         = number
    machine_type  = string
    firewall_tags = list(string)
    boot_disk     = string
    gcp_labels    = map(string)
    gcp_os_code   = string
    gcp_type_code = string
    disk_type     = string
    disk_size     = string
  })
}

variable "network_info" {
  description = "Map of strings with Networking project, VPC, and DNS info"
  type = object({
    project     = string
    vpc         = string
    subnet      = string
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

variable "http_lb"{
    description     = "Load balancer info"
    type = object({
        lb_type       = string
        backend_port  = number
        request_path  = string
    })

    validation {
      condition     = contains(["internal", "external", "none"], var.http_lb.lb_type)
      error_message = "Valid values for var: http_lb.lb_type are (internal, external, none)."
  } 
}
