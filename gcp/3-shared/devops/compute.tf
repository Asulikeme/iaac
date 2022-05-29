data "google_compute_default_service_account" "default" {
  project = trimprefix(module.devops_project.project_id, "projects/")
}

resource "google_compute_disk" "devops_attached_disks" {
  project = trimprefix(module.devops_project.project_id, "projects/")
  name    = "gcpcosappdvops01${var.gcp_environment_code}-apps-disk"
  type    = "pd-ssd"
  zone    = var.gcp_primary_zone
  size    = "10"
}

resource "google_compute_disk_resource_policy_attachment" "devops_attachment" {
  name    = "devops-snapshot-policy"
  disk    = google_compute_disk.devops_attached_disks.name
  zone    = var.gcp_primary_zone
  project = trimprefix(module.devops_project.project_id, "projects/")
}

resource "google_compute_instance" "devops_compute" {
  project      = trimprefix(module.devops_project.project_id, "projects/")
  name         = "gcpcosappdvops01${var.gcp_environment_code}"
  machine_type = "n2d-standard-2"
  zone         = var.gcp_primary_zone
  allow_stopping_for_update = true

  tags = [
    "allow-linux-defaults"
  ]

  boot_disk {
    initialize_params {
      image = "gc-proj-art-pr-06b5/cswg-base-centos7-image-1634823398"
    }
  }

  attached_disk {
    source = google_compute_disk.devops_attached_disks.self_link
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


resource "google_dns_record_set" "compute_dns" {
  name         = "${google_compute_instance.devops_compute.name }.${var.gcp_dns_suffix}."
  managed_zone = "${var.gcp_dns_zone}"
  project      = "${var.gcp_dns_project}"
  type         = "A"
  ttl          = 300
  rrdatas = ["${google_compute_instance.devops_compute.network_interface[0].network_ip}"]
}