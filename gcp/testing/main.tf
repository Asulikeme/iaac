# Code block for storage accounts

resource "random_string" "prefix" {
  length  = 4
  upper   = false
  special = false
}

module "cloud_storage" {
  source     = "../modules/tf-gcs"
  project_id = var.project_id
  prefix     = "multiple-buckets-${random_string.prefix.result}"
#   location   = "us-east1"
  location = var.location
  storage_class = var.storage_class

  names = ["one", "two"]
  bucket_policy_only = {
    "one" = true
    "two" = true
  }
  folders = {
    "two" = ["dev", "prod"]
  }

  lifecycle_rules = [{
    action = {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
    condition = {
      age                   = "10"
      matches_storage_class = "MULTI_REGIONAL,STANDARD,DURABLE_REDUCED_AVAILABILITY"
    }
  }]
}


# Code block for VPC and Subnet

locals {
  subnet_01 = "${var.network_name}-subnet-01"
  subnet_02 = "${var.network_name}-subnet-02"
  subnet_03 = "${var.network_name}-subnet-03"
  subnet_04 = "${var.network_name}-subnet-04"
}

module "test-vpc-module" {
  source       = "../modules/tf-network"
  project_id   = var.project_id
  network_name = var.network_name

  subnets = [
    {
      subnet_name   = local.subnet_01
      subnet_ip     = "10.10.10.0/24"
      subnet_region = var.region
    },
    {
      subnet_name           = local.subnet_02
      subnet_ip             = "10.10.20.0/24"
      subnet_region         = var.region
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
    {
      subnet_name               = local.subnet_03
      subnet_ip                 = "10.10.30.0/24"
      subnet_region             = var.region
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_15_MIN"
      subnet_flow_logs_sampling = 0.9
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
    },
    {
      subnet_name   = local.subnet_04
      subnet_ip     = "10.10.40.0/24"
      subnet_region = var.region
    },
  ]

  secondary_ranges = {
    (local.subnet_01) = [
      {
        range_name    = "${local.subnet_01}-01"
        ip_cidr_range = "192.168.64.0/24"
      },
      {
        range_name    = "${local.subnet_01}-02"
        ip_cidr_range = "192.168.65.0/24"
      },
    ]

    (local.subnet_02) = []

    (local.subnet_03) = [
      {
        range_name    = "${local.subnet_03}-01"
        ip_cidr_range = "192.168.66.0/24"
      },
    ]
  }

  firewall_rules = [
    {
      name      = "allow-ssh-ingress"
      direction = "INGRESS"
      ranges    = ["0.0.0.0/0"]
      allow = [{
        protocol = "tcp"
        ports    = ["22"]
      }]
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    {
      name      = "deny-udp-egress"
      direction = "INGRESS"
      ranges    = ["0.0.0.0/0"]
      deny = [{
        protocol = "udp"
        ports    = null
      }]
    },
  ]

    routes = [
    {
      name              = "${var.network_name}-egress-inet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    },
  ]
}



# provider "random" {
#   version = "~> 2.0"
# }

resource "random_pet" "main" {
  length    = 1
  prefix    = "simple-example"
  separator = "-"
}

module "kms" {
  source     = "../modules/tf-kms"
  project_id = var.project_id
  keyring    = random_pet.main.id
  location   = "global"
  keys       = ["one", "two"]
  # keys can be destroyed by Terraform
  prevent_destroy = false
}