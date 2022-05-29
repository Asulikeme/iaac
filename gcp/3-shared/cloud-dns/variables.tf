# Project ID's amd Shared VPC names

variable "hub_project" {
  default = "gc-proj-nw-sh-0ad7"
}

variable "hub_network" {
  default = "hub-core-sharedvpc"
}

variable "prod_project" {
  default = "gc-proj-nw-shpr-df4e"
}

variable "prod_network" {
  default = "prod-core-sharedvpc"
}

variable "nonprod_project" {
  default = "gc-proj-nw-shnp-8211"
}

variable "nonprod_network" {
  default = "nonprod-core-sharedvpc"
}

# Variables for Cloud DNS - HUB Hosted Zone

variable "hub_zone_name" {
  description = "DNS zone name."
  default     = "gcp-cswg-com"
}

variable "hub_zone_domain" {
  description = "Zone domain."
  default     = "gcp.cswg.com."
}

variable "hub_zone_labels" {
  type        = map(any)
  description = "A set of key/value label pairs to assign to this ManagedZone"
  default = {
    org = "cswg",
    env = "shared",
    cost-center = "is310",
    app-code = "dns",
    department = "cloud",
    bucket-name = "na",
    backup = "na",
    created-by = "terraform",
    owner-maintainer = "cloud-team",
    primary-app-owner = "cloud-team",
    maintenance-window = "na",
    os = "na"
  }
}

# Name server IP Addresses for DNS Forwarding
variable "name_server1" {
  default = "10.0.8.240"
}

variable "name_server2" {
  default = "10.0.8.190"
}

variable "name_server3" {
  default = "10.0.32.20"
}


# Variables for Cloud DNS Peering - Production Hosted Zone

variable "prod_peering_zone_name" {
  description = "DNS zone name."
  default     = "prod-gcp-cswg-com"
}

variable "prod_peering_zone_domain" {
  description = "Zone domain."
  default     = "prod.gcp.cswg.com."
}

variable "prod_peering_zone_labels" {
  type        = map(any)
  description = "A set of key/value label pairs to assign to this ManagedZone"
  default = {
    org = "cswg",
    env = "shared-prod",
    cost-center = "is310",
    app-code = "dns",
    department = "cloud",
    bucket-name = "na",
    backup = "na",
    created-by = "terraform",
    owner-maintainer = "cloud-team",
    primary-app-owner = "cloud-team",
    maintenance-window = "na",
    os = "na"

  }
}

# Variables for Cloud DNS Peering - Non-prod Hosted Zone

variable "nonprod_peering_zone_name" {
  description = "DNS zone name."
  default     = "nonprod-gcp-cswg-com"
}

variable "nonprod_peering_zone_domain" {
  description = "Zone domain."
  default     = "nonprod.gcp.cswg.com."
}

variable "nonprod_peering_zone_labels" {
  type        = map(any)
  description = "A set of key/value label pairs to assign to this ManagedZone"
  default = {
    org = "cswg",
    env = "shared-nonprod",
    cost-center = "is310",
    app-code = "dns",
    department = "cloud",
    bucket-name = "na",
    backup = "na",
    created-by = "terraform",
    owner-maintainer = "cloud-team",
    primary-app-owner = "cloud-team",
    maintenance-window = "na",
    os = "na"

  }
}
