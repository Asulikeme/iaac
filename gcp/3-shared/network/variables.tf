variable "gcp_cloud_code" {
  type        = string
  description = "length upto 3 chars including the -.Cloud code will be gc- for GCP terraform"
  default     = "gcp-"
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

# variable "hub_project" {
#   default = "gc-proj-nw-sh-0ad7"

# }

variable "prod_project" {
  default = "gcp-proj-nw-sprod-01"
}

# variable "shared_secret1" {
#   description = "Shared Secret for the tunnel - remote-0"
#   type        = string
#   sensitive   = true
# }

# variable "shared_secret2" {
#   description = "Shared Secret for the tunnel - remote-1"
#   type        = string
#   sensitive   = true
# }

variable "nonprod_project" {
  default = "gcp-proj-nw-snprod-02"
}

variable "terraform_account" {
  default = "sada-535@cswg-sada.iam.gserviceaccount.com	"

}

variable "prod_cidr" {
  default = "10.230.0.0/16"
}

variable "nonprod_cidr" {
  default = "10.231.0.0/16"
}

# variable "hub_cidr" {
#   #expandable to /22
#   default = "10.228.0.0/24"
# }

# variable "hub_mgmt_subnet" {
#   default = "10.228.8.0/24"
# }


# variable "hub_wan_subnet" {
#   default = "10.228.12.0/24"
# }

variable "nonprod_paas_subnet" {
  #expandable to a /22
  default = "10.228.32.0/24"
}

variable "prod_paas_subnet" {
  #expandable to a /22
  default = "10.228.48.0/24"
}

variable "prod_ilb_proxy_cidr" {
  default = "172.17.0.0/23"
}
variable "nonprod_ilb_proxy_cidr" {
  default = "172.17.64.0/23"
}

variable "cloud_router_customroute_config" {
  description = "Map of objects that will contain the custom route values."
  type = object({
    groups    = list(string)
    ip_ranges = map(string)

  })

}

variable "gcp_fw_rfc1918" {
  type = list(string)
  description = "Default RFC 1918 IPs"
}