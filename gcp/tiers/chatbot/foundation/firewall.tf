resource "google_compute_firewall" "allow_chatbot_defaults" {
  project     = var.network_info.project
  name        = "gc-fw-in-ips-rfc1918-tag-allow-chatbot-allow"
  network     = var.network_info.vpc
  description = "Allow Chatbot Defaults"

  source_ranges = var.gcp_fw_rfc1918
  
  allow {
    protocol = "tcp"
    ports    = ["5555", "5029", "7777", "8080", "18887", "18888", "9200", "9300"]
  }
  target_tags = ["allow-chatbot-defaults"]
}