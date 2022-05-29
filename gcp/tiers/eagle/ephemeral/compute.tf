data "google_compute_default_service_account" "default" {
  project = var.eagle_project_name
}

module "eagle-lb-https" {
  source            = "GoogleCloudPlatform/lb-http/google"
  version           = "~> 6.1"
  count = var.eagle_lb_count

  project           = var.eagle_project_name
  firewall_projects = [var.network_info.project]
  firewall_networks = [var.network_info.vpc]
  http_forward = true
  https_redirect = true
  ssl = true
  certificate = google_compute_ssl_certificate.cswg_com_wildcard[0].certificate
  private_key = google_compute_ssl_certificate.cswg_com_wildcard[0].private_key

  name              = "eagle${var.gcp_environment_code}"
  target_tags       = ["eagle-healthcheck"]
  backends = {
    default = {
      protocol                        = "HTTP"
      description                     = null
      port                            = 80
      port_name                       = "eagle${var.gcp_environment_code}-http"
      timeout_sec                     = 10
      enable_cdn                      = false
      connection_draining_timeout_sec = null
      security_policy                 = null
      session_affinity                = null
      affinity_cookie_ttl_sec         = null
      custom_request_headers          = null
      custom_response_headers         = null

      health_check = {
        check_interval_sec  = null
        timeout_sec         = null
        healthy_threshold   = null
        unhealthy_threshold = null
        request_path        = "/public/index.html"
        port                = 80
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
          group                        = google_compute_instance_group.eagle_instance_group[0].self_link
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


resource "google_compute_instance_group" "eagle_instance_group" {
  project   = var.eagle_project_name
  name      = "eagle${var.gcp_environment_code}-instance-group"
  count     = var.eagle_lb_count
  zone      = var.gcp_primary_zone
  instances = google_compute_instance.eagle_compute.*.self_link

  lifecycle {
    create_before_destroy = true
  }

  named_port {
    name = "eagle${var.gcp_environment_code}-http"
    port = "80"
  }
}

resource "google_compute_disk" "eagle_attached_disks" {
  project = var.eagle_project_name
  count   = var.eagle_compute_instances.count
  name    = "${format("gcpcosappegle%02d${var.gcp_environment_code}", count.index + 1)}-u01-disk"
  type    = "pd-ssd"
  zone    = var.gcp_primary_zone
  size    = "100"
}

resource "google_compute_disk_resource_policy_attachment" "eagle_disk_snapshot" {
  name = "eagle-snapshot-policy"
  count   = var.eagle_compute_instances.count
  disk    = google_compute_disk.eagle_attached_disks[count.index].name
  zone = var.gcp_primary_zone
  project = var.eagle_project_name
}

resource "google_compute_instance" "eagle_compute" {
  project                   = var.eagle_project_name
  name                      = format("gcpcosappegle%02d${var.gcp_environment_code}", count.index + 1)
  count                     = var.eagle_compute_instances.count
  machine_type              = var.eagle_compute_instances.machine_type
  zone                      = var.gcp_primary_zone
  allow_stopping_for_update = true
  labels                    = var.eagle_compute_instances.gcp_labels

  tags = var.eagle_compute_instances.firewall_tags

  boot_disk {
    initialize_params {
      image = var.eagle_compute_instances.boot_disk
    }
  }

  attached_disk {
    source = google_compute_disk.eagle_attached_disks.*.self_link[count.index + 0]
  }

  network_interface {
    network    = "projects/${var.network_info.project}/global/networks/${var.network_info.vpc}"
    subnetwork = "projects/${var.network_info.project}/regions/${var.gcp_primary_region}/subnetworks/${var.network_info.subnet}"
  }

  service_account {
    email = data.google_compute_default_service_account.default.email
    scopes = ["cloud-platform", "logging-write", "monitoring-write", "monitoring", "monitoring-read"]
  }
}

resource "google_dns_record_set" "A_record_dns" {
  count        = var.eagle_compute_instances.count
  name         = "${google_compute_instance.eagle_compute[count.index].name}.${var.gcp_dns_suffix}."
  managed_zone = "${var.gcp_dns_zone}"
  project      = "${var.gcp_dns_project}"
  type         = "A"
  ttl          = 300
  rrdatas = ["${google_compute_instance.eagle_compute[count.index].network_interface[0].network_ip}"]
}