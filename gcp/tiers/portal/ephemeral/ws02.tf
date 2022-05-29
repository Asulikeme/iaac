
###
## WS02 API Gateway
#

module "portal-api-lb-https" {
  source            = "GoogleCloudPlatform/lb-http/google"
  version           = "~> 6.1"

  project           = var.portal_project_name
  firewall_projects = [var.network_info.project]
  firewall_networks = [var.network_info.vpc]
  http_forward = true
  https_redirect = true
  ssl = true
//  ssl_certificates = [google_compute_ssl_certificate.cswg_com_wildcard.name_prefix]

  certificate = google_compute_ssl_certificate.cswg_com_wildcard.certificate
  private_key = google_compute_ssl_certificate.cswg_com_wildcard.private_key

  name              = "gcpcosappcpapi${var.gcp_environment_code}"
  target_tags       = ["api-healthcheck"]
  backends = {
    default = {
      protocol                        = "HTTP"
      description                     = null
      port                            = 7777
      port_name                       = "gcpcosappcpapi${var.gcp_environment_code}-http"
      timeout_sec                     = 10
      enable_cdn                      = false
      // Required Inputs
      connection_draining_timeout_sec = null
      security_policy                 = null
      session_affinity                = "CLIENT_IP"
      affinity_cookie_ttl_sec         = null
      custom_request_headers          = null
      custom_response_headers         = null

      health_check = {
        check_interval_sec  = null
        timeout_sec         = null
        healthy_threshold   = null
        unhealthy_threshold = null
        request_path        = "/public/index.html"
        port                = 7777
        host                = null
        logging             = null
      }

      log_config = {
        enable = true
        sample_rate = 1.0
      }

      groups = [
        {
          # Each node pool instance group should be added to the backend.
          group                        = google_compute_instance_group.ws02_api_gateway.self_link
          balancing_mode               = null
          capacity_scaler              = null
          description                  = null
          max_connections              = null
          max_connections_per_instance = null
          max_connections_per_endpoint = null
          max_rate                     = null
          max_rate_per_instance        = null
          max_rate_per_endpoint        = null
          max_utilization              = null
        },
      ]
      iap_config = {
        enable               = false
        oauth2_client_id     = ""
        oauth2_client_secret = ""
      }
    }
  }
}

resource "google_compute_instance_group" "ws02_api_gateway" {
  project   = var.portal_project_name
  name      = "gcpcosappcpapi${var.gcp_environment_code}-instance-group"
  zone      = var.gcp_primary_zone
  instances = ["${element(google_compute_instance.ws02_api_gateway.*.self_link, 2)}", "${element(google_compute_instance.ws02_api_gateway.*.self_link, 1)}" ]

  lifecycle {
    create_before_destroy = true
  }
  named_port {
    name = "gcpcosappcpapi${var.gcp_environment_code}-http"
    port = "7777"
  }
}

resource "google_compute_disk" "ws02_attached_disks" {
  project = var.portal_project_name
  count   = 2
  name    = "${format("gcpcosappcpapi${var.gcp_environment_code}%02d", count.index + 1)}-u01-disk"
  type    = "pd-ssd"
  zone    = var.gcp_primary_zone
  size    = "50"
}

resource "google_compute_disk_resource_policy_attachment" "ws02_attachment" {
  name  = "portal-snapshot-policy"
  count = 2
  disk  = google_compute_disk.ws02_attached_disks[count.index].name
  zone  = "us-east4-c"
  project = var.portal_project_name
}

resource "google_compute_instance" "ws02_api_gateway" {
  project      = var.portal_project_name
  name         = format("gcpcosappcpapi%02d${var.gcp_environment_code}", count.index + 1)
  count        = 2
  #machine_type = "custom-4-24576"
  machine_type = "custom-2-8192"
  zone         = var.gcp_primary_zone
  allow_stopping_for_update = true

  # We're tagging the instance with the tag specified in the firewall rule
  tags = [
    "allow-icmp",
    "allow-ssh",
    "allow-int-https",
    "allow-portal-defaults",
    "api-healthcheck",
    "allow-portal-api", 
    "allow-linux-defaults"
  ]

  boot_disk {
    initialize_params {
      image = "gc-proj-art-pr-06b5/cswg-base-centos7-java11-image-1632858032"
    }
  }

  attached_disk {
    source = "${google_compute_disk.ws02_attached_disks.*.self_link[count.index + 0]}"
  }

  # Stub Startup Script
  # metadata_startup_script = file("${path.module}/../shared/startup_script.sh")

  # Launch the instance in the public subnetwork
  network_interface {
    network    = "projects/${var.network_info.project}/global/networks/${var.network_info.vpc}"
    subnetwork = "projects/${var.network_info.project}/regions/${var.gcp_primary_region}/subnetworks/${var.network_info.subnet}"
  }
}

resource "google_dns_record_set" "api_dns" {
  count        = 2
  name         = "${google_compute_instance.ws02_api_gateway[count.index].name}.${var.gcp_dns_suffix}."
  managed_zone = "${var.gcp_dns_zone}"
  project      = "${var.gcp_dns_project}"
  type         = "A"
  ttl          = 300
  rrdatas = ["${google_compute_instance.ws02_api_gateway[count.index].network_interface[0].network_ip}"]
}