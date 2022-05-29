resource "google_compute_firewall" "allow_mosaic_defaults" {
  project     = var.network_info.project
  name        = "gc-fw-in-ips-rfc1918-tag-allow-mosaic-defaults"
  network     = var.network_info.vpc
  description = "Allow default port access from onprem"

  source_ranges = ["10.0.0.0/8","172.16.0.0/12","192.168.0.0/16"]

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "5000", "7777"]
  }
  target_tags = ["allow-mosaic-defaults"]
}