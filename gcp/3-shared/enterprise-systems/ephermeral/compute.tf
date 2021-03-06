data "google_compute_default_service_account" "default" {
  project = var.es_project_name
}

module "gce-ilb" {
  source       = "GoogleCloudPlatform/lb-internal/google"
  version      = "~> 2.0"
  #count        = var.es_lb_count
  region       = var.gcp_primary_region
  name         = "${var.gcp_cloud_code}${var.gcp_loc_global_code}${var.gcp_ilb_code}${var.gcp_application_code}${var.gcp_environment_code}"
  ports        = ["389"]
  project      = var.es_project_name
  network    = var.network_info.vpc
  subnetwork = var.network_info.subnet
  network_project = var.network_info.project


  health_check = {
        type                = "tcp"
        check_interval_sec  = 1
        healthy_threshold   = 4
        timeout_sec         = 1
        unhealthy_threshold = 5
        response            = ""
        proxy_header        = "NONE"
        port                = 389
        port_name           = "gcpmsdc${var.gcp_environment_code}-http"
        request             = ""
        request_path        = "/cloudio/ping.html"
        host                = ""
        enable_log          = null
      }
  target_tags  = ["gcpmsdc${var.gcp_environment_code}-http"]
  source_tags  = ["gcpmsdc${var.gcp_environment_code}-http"]
  backends     = [
    {
      description = "Instance group for internal-load-balancer es"
      group       = google_compute_instance_group.es_group.self_link
    }
  ]
}

resource "google_compute_instance_group" "es_group" {
  project   = var.es_project_name
  name      = "gcpmsdc${var.gcp_environment_code}-instance-group"
 # count     = var.es_lb_count
  zone      = var.gcp_primary_zone
  instances = google_compute_instance.es_compute.*.self_link

  lifecycle {
    create_before_destroy = true
  }

  named_port {
    name = "gcpmsdc${var.gcp_environment_code}-http"
    port = "8080"
  }
}
resource "google_compute_disk" "es_attached_disks" {
  project = var.es_project_name
  name    = "${format("gcpmsdc${var.gcp_environment_code}%02d", count.index + 1)}-u01-disk"
  count   = var.es_compute_instances.count
  type    = "pd-ssd"
  zone    = var.gcp_primary_zone
  size    = "50"
}

resource "google_compute_disk_resource_policy_attachment" "es_attachment" {
  name    = "es-snapshot-policy"
  count   = var.es_compute_instances.count
  disk    = google_compute_disk.es_attached_disks[count.index].name
  zone    = var.gcp_primary_zone
  project = var.es_project_name
}


resource "google_compute_instance" "es_compute" {
  project                   = var.es_project_name
  name                      = format("gcpmsdc%02d${var.gcp_environment_code}", count.index + 1)
  count                     = var.es_compute_instances.count
  machine_type              = var.es_compute_instances.machine_type
  zone                      = var.gcp_primary_zone
  allow_stopping_for_update = true

  # We're tagging the instance with the tag specified in the firewall rule
  tags = var.es_compute_instances.firewall_tags

  boot_disk {
    initialize_params {
      image = var.es_compute_instances.boot_disk
    }
  }

  attached_disk {
    source = google_compute_disk.es_attached_disks.*.self_link[count.index + 0]
  }

  # Stub Startup Script
  # metadata_startup_script = file("${path.module}/../shared/startup_script.sh")

  # Launch the instance in the public subnetwork
  network_interface {
    network    = "projects/${var.network_info.project}/global/networks/${var.network_info.vpc}"
    subnetwork = "projects/${var.network_info.project}/regions/${var.gcp_primary_region}/subnetworks/${var.network_info.subnet}"
  }

  service_account {
    email = data.google_compute_default_service_account.default.email
    scopes = ["cloud-platform", "logging-write", "monitoring-write", "monitoring", "monitoring-read"]
  }
}

resource "google_dns_record_set" "compute_dns" {
  name         = "${google_compute_instance.es_compute[count.index].name }.${var.gcp_dns_suffix}."
  count =  var.es_compute_instances.count
  managed_zone = "${var.gcp_dns_zone}"
  project      = "${var.gcp_dns_project}"
  type         = "A"
  ttl          = 300
  rrdatas = ["${google_compute_instance.es_compute[count.index].network_interface[0].network_ip}"]
}

