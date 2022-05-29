data "google_compute_default_service_account" "default" {
  project = var.project_name
}

resource "google_compute_ssl_certificate" "cswg_com_wildcard" {
  name        = "cswg-wildcard-cert"
  project     = var.project_name
  count       = lower(var.http_lb.lb_type) != "none" ? 1 : 0 
  private_key = file("../../../certs/cswg-wildcard-with-chain-private-key")
  certificate = file("../../../certs/cswg-wildcard-with-chain")
}

module "internal-lb-https" {
  source       = "GoogleCloudPlatform/lb-internal/google"
  version      = "~> 2.0"
  count        = lower(var.http_lb.lb_type) == "internal" ? 1 : 0 
  region       = var.gcp_primary_region
  name         = "${var.gcp_cloud_code}${var.gcp_loc_global_code}${var.gcp_ilb_code}${var.gcp_app_code}-${var.gcp_environment_code}"
  ports        = ["80"]
  project      = var.project_name
  network    = var.network_info.vpc
  subnetwork = var.network_info.subnet
  network_project = var.network_info.project


  health_check = {
        type                = "http"
        check_interval_sec  = 1
        healthy_threshold   = 4
        timeout_sec         = 1
        unhealthy_threshold = 5
        response            = ""
        proxy_header        = "NONE"
        port                = var.http_lb.backend_port
        port_name           = "${var.gcp_app_code}${var.gcp_environment_code}-http"
        request             = ""
        request_path        = var.http_lb.request_path
        host                = ""
        enable_log          = null
      }
  target_tags  = ["${var.gcp_app_code}-healthcheck"]
  source_tags  = ["${var.gcp_app_code}-healthcheck-source"]
  backends     = [
    {
      description = "Instance group for internal-load-balancer ${var.gcp_app_code}"
      group       = google_compute_instance_group.instance_group[0].self_link
    }
  ]
}

module "external-lb-https" {
  source            = "GoogleCloudPlatform/lb-http/google"
  version           = "~> 6.1"
  count             = lower(var.http_lb.lb_type) == "external" ? 1 : 0 
  project           = var.project_name
  firewall_projects = [var.network_info.project]
  firewall_networks = [var.network_info.vpc]
  http_forward      = true
  https_redirect    = true
  ssl               = true
  certificate       = google_compute_ssl_certificate.cswg_com_wildcard[0].certificate
  private_key       = google_compute_ssl_certificate.cswg_com_wildcard[0].private_key

  name              = "${var.gcp_cloud_code}${var.gcp_loc_global_code}${var.gcp_xlb_code}${var.gcp_app_code}-${var.gcp_environment_code}"
  target_tags       = ["${var.gcp_app_code}-healthcheck"]
  backends = {
    default = {
      protocol                        = "HTTP"
      description                     = null
      port                            = var.http_lb.backend_port
      port_name                       = "${var.gcp_app_code}${var.gcp_environment_code}-http"
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
        request_path        = var.http_lb.request_path
        port                = var.http_lb.backend_port
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
          group                        = google_compute_instance_group.instance_group[0].self_link
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

resource "google_compute_instance_group" "instance_group" {
  project   = var.project_name
  name      = "${var.gcp_app_code}${var.gcp_environment_code}-instance-group"
  count     = lower(var.http_lb.lb_type) != "none" ? 1 : 0 
  zone      = var.gcp_primary_zone
  instances = google_compute_instance.compute.*.self_link

  lifecycle {
    create_before_destroy = true
  }

  named_port {
    name = "${var.gcp_app_code}${var.gcp_environment_code}-http"
    port = var.http_lb.backend_port
  }
}

resource "google_compute_resource_policy" "snapshot_policy" {
  name   = "${var.gcp_app_code}-snapshot-policy"
  project = var.project_name
  region = var.gcp_primary_region
  snapshot_schedule_policy {
    schedule {
      hourly_schedule {
        hours_in_cycle = 20
        start_time     = "23:00"
      }
    }
    retention_policy {
      max_retention_days    = 10
      on_source_disk_delete = "APPLY_RETENTION_POLICY"
    }
    snapshot_properties {
      labels = {
        backup = "true"
      }
      storage_locations = ["us"]
      guest_flush       = false
    }
  }
}

resource "google_compute_disk_resource_policy_attachment" "snapshot_policy_attachment" {
  name    = google_compute_resource_policy.snapshot_policy.name
  count   = var.compute_instances.count
  disk    = google_compute_disk.attached_disks[count.index].name
  zone    = var.gcp_primary_zone
  project = var.project_name
}

resource "google_compute_disk" "attached_disks" {
  project = var.project_name
  count   = var.compute_instances.count
  name    = "${format("gcp${var.compute_instances.gcp_os_code}${var.compute_instances.gcp_type_code}${var.gcp_app_code}%02d${var.gcp_environment_code}", count.index + 1)}-u01-disk"
  type    = var.compute_instances.disk_type
  zone    = var.gcp_primary_zone
  size    = var.compute_instances.disk_size
}

resource "google_compute_instance" "compute" {
  project                   = var.project_name
  name                      = format("gcp${var.compute_instances.gcp_os_code}${var.compute_instances.gcp_type_code}${var.gcp_app_code}%02d${var.gcp_environment_code}", count.index + 1)
  count                     = var.compute_instances.count
  machine_type              = var.compute_instances.machine_type
  zone                      = var.gcp_primary_zone
  allow_stopping_for_update = true
  labels                    = var.compute_instances.gcp_labels

  tags = var.compute_instances.firewall_tags

  boot_disk {
    initialize_params {
      image = var.compute_instances.boot_disk
    }
  }

  attached_disk {
    source = google_compute_disk.attached_disks.*.self_link[count.index + 0]
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
  count        = var.compute_instances.count
  name         = "${google_compute_instance.compute[count.index].name}.${var.network_info.dns_suffix}."
  managed_zone = "${var.network_info.dns_zone}"
  project      = "${var.network_info.dns_project}"
  type         = "A"
  ttl          = 300
  rrdatas = ["${google_compute_instance.compute[count.index].network_interface[0].network_ip}"]
}