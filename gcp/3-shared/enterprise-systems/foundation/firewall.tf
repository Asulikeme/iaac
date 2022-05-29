resource "google_compute_firewall" "allow_ensy_dc_defaults" {
  project     = var.network_info.project
  name        = "gc-fw-in-ips-rfc1918-tag-allow-ensy-dc-defaults"
  network     = var.network_info.vpc
  description = "Allow default port access from onprem"

  source_ranges = ["10.0.0.0/8","172.16.0.0/12","192.168.0.0/16"]

  allow {
    protocol = "tcp"
    ports    = ["53", "88", "464", "389","636","3268","3269","445","135","9389","49152-65535"]
  }
  allow {
    protocol = "udp"
    ports     = ["53","88","464","389","636","123","445"]
  }
  allow {
    protocol = "icmp"
  }

  target_tags = ["allow-ensy-dc-defaults"]
}