###
## Portal Specific Firewall Rules
#


resource "google_compute_firewall" "allow_int_https" {
  project     = var.network_info.project
  name        = "fw-allow-int-https"
  network     = var.network_info.vpc
  description = "Allow http and https"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  target_tags = ["allow-int-https"]
}


resource "google_compute_firewall" "allow_portal_defaults" {
  project     = var.network_info.project
  name        = "fw-allow-portal-default"
  network     = var.network_info.vpc
  description = "Allow Portal Defaults"

  source_ranges = ["10.0.0.0/8","172.16.0.0/12","192.168.0.0/16"]
  
  allow {
    protocol = "tcp"
    ports    = ["22", "7777"]
  }
  target_tags = ["allow-portal-defaults"]
}

resource "google_compute_firewall" "allow_portal_cloudsql" {
  project     = var.network_info.project
  name        = "fw-allow-portal-cloudsql"
  network     = var.network_info.vpc
  description = "Allow Portal CloudSQL Postgresql Access"

  source_ranges = ["10.0.0.0/8","172.16.0.0/12","192.168.0.0/16"]

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }
  target_tags = ["allow-portal-cloudsql"]
}

resource "google_compute_firewall" "allow_portal_redis" {
  project     = var.network_info.project
  name        = "fw-allow-portal-redis"
  network     = var.network_info.vpc
  description = "Allow Portal MemoryStore Redis Access"

  source_ranges = var.gcp_fw_rfc1918

  allow {
    protocol = "tcp"
    ports    = ["6379"]
  }
  target_tags = ["allow-portal-redis"]
}

resource "google_compute_firewall" "allow_portal_api" {
  project     = var.network_info.project
  name        = "gc-fw-in-ips-rfc1918-tag-allow-portal-api-allow"
  network     = var.network_info.vpc
  description = "Allow portal APIs from onprem"

  source_ranges = ["10.0.0.0/8","172.16.0.0/12","192.168.0.0/16"]

  allow {
    protocol = "tcp"
    ports    = ["9444","9443","9763","8280", "8243"]
  }
  target_tags = ["allow-portal-api"]
}

resource "google_compute_firewall" "allow_portal_njs" {
  project     = var.network_info.project
  name        = "gc-fw-in-ips-rfc1918-tag-allow-portal-njs-allow"
  network     = var.network_info.vpc
  description = "Allow portal NJS from onprem"

  source_ranges = ["10.0.0.0/8","172.16.0.0/12","192.168.0.0/16"]

  allow {
    protocol = "tcp"
    ports    = ["3002", "4000", "4004", "8093"]
  }
  target_tags = ["allow-portal-njs"]
}

resource "google_compute_firewall" "allow_portal_scs" {
  project     = var.network_info.project
  name        = "gc-fw-in-ips-rfc1918-tag-allow-portal-scs-allow"
  network     = var.network_info.vpc
  description = "Allow portal SCS from onprem"

  source_ranges = ["10.0.0.0/8","172.16.0.0/12","192.168.0.0/16"]

  allow {
    protocol = "tcp"
    ports    = ["8093", "8090", "8092", "8091", "8094", "8095", "8096", "8097", "9090", "9091", "9092", "9093", "9083", "9082", "8099", "9094"]
  }
  target_tags = ["allow-portal-scs"]
}