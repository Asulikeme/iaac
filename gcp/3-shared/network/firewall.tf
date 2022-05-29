####
## Default Firewall Rules
#

# resource "google_compute_firewall" "allow_ingress_traffic_from_vpn" {
#   name    = "allow-ingress-traffic-to-vpn"
#   network = google_compute_network.hub.name
#   project = var.hub_project

#   allow {
#     protocol = "tcp"
#   }

#   source_ranges = [var.prod_cidr, var.nonprod_cidr]
#   priority      = 1000
#   direction     = "INGRESS"

#   #turn logging on
#   log_config {
#     metadata = "INCLUDE_ALL_METADATA"
#   }

# }

# resource "google_compute_firewall" "allow_egress_traffic_to_vpn" {
#   name    = "allow-egress-traffic-to-vpn"
#   network = google_compute_network.hub.name
#   project = var.hub_project

#   allow {
#     protocol = "tcp"
#   }

#   destination_ranges = [var.prod_cidr, var.nonprod_cidr]
#   priority           = 1000
#   direction          = "EGRESS"
#   #turn logging on
#   log_config {
#     metadata = "INCLUDE_ALL_METADATA"
#   }
# }

# resource "google_compute_firewall" "deny_ingress_traffic_from_internet_hub" {
#   name    = "deny-all-ingress-traffic"
#   network = google_compute_network.hub.name
#   project = var.hub_project

#   deny {
#     protocol = "all"
#   }

#   source_ranges = ["0.0.0.0/0"]
#   priority      = 2000
#   direction     = "INGRESS"
#   #turn logging on
#   log_config {
#     metadata = "INCLUDE_ALL_METADATA"
#   }
# }

# resource "google_compute_firewall" "allow_egress_traffic_to_internet_hub" {
#   name    = "allow-all-egress-traffic"
#   network = google_compute_network.hub.name
#   project = var.hub_project

#   allow {
#     protocol = "all"
#   }

#   destination_ranges = ["0.0.0.0/0"]
#   priority           = 2000
#   direction          = "EGRESS"
#   #turn logging on
#   log_config {
#     metadata = "INCLUDE_ALL_METADATA"
#   }
# }


# resource "google_compute_firewall" "deny_ingress_traffic_from_internet_prod" {
#   name    = "deny-all-ingress-traffic-prod"
#   network = google_compute_network.prod.name
#   project = var.prod_project

#   deny {
#     protocol = "all"
#   }

#   source_ranges = ["0.0.0.0/0"]
#   priority      = 2000
#   direction     = "INGRESS"
#   #turn logging on
#   log_config {
#     metadata = "INCLUDE_ALL_METADATA"
#   }
# }

# resource "google_compute_firewall" "allow_egress_traffic_to_internet_prod" {
#   name    = "allow-all-egress-traffic-prod"
#   network = google_compute_network.prod.name
#   project = var.prod_project

#   allow {
#     protocol = "all"
#   }

#   destination_ranges = ["0.0.0.0/0"]
#   priority           = 2000
#   direction          = "EGRESS"
#   #turn logging on
#   log_config {
#     metadata = "INCLUDE_ALL_METADATA"
#   }
# }

resource "google_compute_firewall" "deny_ingress_traffic_from_internet_nonprod" {
  name    = "deny-all-ingress-traffic-nonprod"
  network = google_compute_network.nonprod.name
  project = var.nonprod_project

  deny {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
  priority      = 2000
  direction     = "INGRESS"
  #turn logging on
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_firewall" "allow_egress_traffic_to_internet_nonprod" {
  name    = "allow-all-egress-traffic"
  network = google_compute_network.nonprod.name
  project = var.nonprod_project

  allow {
    protocol = "all"
  }

  destination_ranges = ["0.0.0.0/0"]
  priority           = 2000
  direction          = "EGRESS"
  #turn logging on
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_firewall" "allow_ingress_linux_from_RFC1918_nonprod" {
  name    = "gc-fw-in-ips-rfc1918-tag-linux-default-allow"
  network = google_compute_network.nonprod.name
  project = var.nonprod_project

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "udp"
    ports    = ["161"]
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  source_ranges = var.gcp_fw_rfc1918
  priority      = 500
  direction     = "INGRESS"


  target_tags = ["allow-linux-defaults"]
}

resource "google_compute_firewall" "allow_ingress_window_from_RFC1918_nonprod" {
  name    = "gc-fw-in-ips-rfc1918-tag-window-default-allow"
  network = google_compute_network.nonprod.name
  project = var.nonprod_project

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["53", "88", "464", "389", "636", "3268", "3269", "3389", "445", "135", "9389", "49152-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["53", "88", "464", "389", "636", "123", "445"]
  }
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  source_ranges = var.gcp_fw_rfc1918
  priority      = 500
  direction     = "INGRESS"

  target_tags = ["allow-window-defaults"]
}

###
##Prod administrative access rules
#
# resource "google_compute_firewall" "allow_ingress_ICMP_from_RFC1918" {
#   name    = "gc-fw-in-ips-rfc1918-tag-allow-icmp-allow"
#   network = google_compute_network.prod.name
#   project = var.prod_project

#   allow {
#     protocol = "icmp"
#   }

#   source_ranges = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
#   priority      = 500
#   direction     = "INGRESS"
#   #turn logging on
#   log_config {
#     metadata = "INCLUDE_ALL_METADATA"
#   }

#   target_tags = ["allow-icmp"]
# }

# resource "google_compute_firewall" "allow_ingress_SSH_from_RFC1918" {
#   name    = "gc-fw-in-ips-rfc1918-tag-allow-ssh-allow"
#   network = google_compute_network.prod.name
#   project = var.prod_project

#   allow {
#     protocol = "tcp"
#     ports    = ["22"]
#   }

#   source_ranges = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
#   priority      = 500
#   direction     = "INGRESS"
#   #turn logging on
#   log_config {
#     metadata = "INCLUDE_ALL_METADATA"
#   }

#   target_tags = ["allow-ssh"]
# }


# resource "google_compute_firewall" "allow_ingress_RDP_from_RFC1918" {
#   name    = "gc-fw-in-ips-rfc1918-tag-allow-rdp-allow"
#   network = google_compute_network.prod.name
#   project = var.prod_project

#   allow {
#     protocol = "tcp"
#     ports    = ["3389"]
#   }
#   allow {
#     protocol = "udp"
#     ports    = ["3389"]
#   }

#   source_ranges = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
#   priority      = 500
#   direction     = "INGRESS"
#   #turn logging on
#   log_config {
#     metadata = "INCLUDE_ALL_METADATA"
#   }

#   target_tags = ["allow-rdp"]
# }

# resource "google_compute_firewall" "allow_ingress_linux_from_RFC1918_prod" {
#   name    = "gc-fw-in-ips-rfc1918-tag-linux-default-allow"
#   network = google_compute_network.prod.name
#   project = var.prod_project

#   allow {
#     protocol = "icmp"
#   }

#   allow {
#     protocol = "tcp"
#     ports    = ["22"]
#   }

#   allow {
#     protocol = "udp"
#     ports    = ["161"]
#   }

#   log_config {
#     metadata = "INCLUDE_ALL_METADATA"
#   }

#   source_ranges = var.gcp_fw_rfc1918
#   priority      = 500
#   direction     = "INGRESS"

#   target_tags = ["allow-linux-defaults"]
# }

# resource "google_compute_firewall" "allow_ingress_window_from_RFC1918_prod" {
#   name    = "gc-fw-in-ips-rfc1918-tag-window-default-allow"
#   network = google_compute_network.prod.name
#   project = var.prod_project

#   allow {
#     protocol = "icmp"
#   }

#   allow {
#     protocol = "tcp"
#     ports    = ["135", "3389"]
#   }

#   log_config {
#     metadata = "INCLUDE_ALL_METADATA"
#   }

#   source_ranges = var.gcp_fw_rfc1918
#   priority      = 500
#   direction     = "INGRESS"

#   target_tags = ["allow-window-defaults"]
# }
