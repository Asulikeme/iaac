resource "google_compute_ssl_certificate" "cswg_com_wildcard" {
  name    = "cswg-wildcard-cert"
  project = var.chatbot_project_name
  count   = var.chatbot_lb_count

  private_key = file("../../../certs/cswg-wildcard-with-chain-private-key")
  certificate = file("../../../certs/cswg-wildcard-with-chain")
}