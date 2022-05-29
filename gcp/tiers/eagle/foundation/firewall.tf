resource "google_compute_firewall" "allow_eagle_ports" {
  project     = var.network_info.project
  name        = "gc-fw-in-ips-rfc1918-tag-allow-eagle-allow"
  network     = var.network_info.vpc
  description = "Allow eagle ports from onprem"

  source_ranges = var.gcp_fw_rfc1918

  allow {
    protocol = "tcp"
    ports    = ["3000", "8080", "50008", "50009", "50010"]
  }
  target_tags = ["allow-eagle"]
}