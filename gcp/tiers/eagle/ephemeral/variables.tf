variable "gcp_cloud_code" {
  description = "Code for GCP resources to use when naming or labeling resources"
  type        = string
  default     = "gc-"
}

variable "gcp_application_code" {
  description = "Code for the application to use when naming or labeling resources"
  type        = string
  default     = "egle-"
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

variable "eagle_compute_instances" {
  description = "Compute instance vars"
  type = object({
    count         = number
    machine_type  = string
    firewall_tags = list(string)
    boot_disk     = string
    gcp_labels    = map(string)
  })
}

variable "zone" {
  description = "Region to build resources in"
  default     = "us-east4-c"
}

variable "eagle_project_name" {
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


variable "gcp_dns_zone" {
  description = "DNS zone to create record in"
  type        = string
}

variable "gcp_dns_suffix" {
  description = "DNS suffix for records"
  type        = string
}

variable "gcp_dns_project" {
  description = "Project that DNS zones are in"
  type        = string
}

variable "eagle_lb_count" {
  description = "Determines whether a load balancer is needed"
  type        = number
}