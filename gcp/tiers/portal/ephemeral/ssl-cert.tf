resource "google_compute_ssl_certificate" "cswg_com_wildcard" {
  name        = "cswg-wildcard-cert"
  project = var.portal_project_name

  // @TODO will need to update this with the right SSL Cert
  private_key = file("../../../certs/cswg-wildcard-with-chain-private-key")
  certificate = file("../../../certs/cswg-wildcard-with-chain")
}