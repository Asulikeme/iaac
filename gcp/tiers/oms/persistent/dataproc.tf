locals {
  dataproc_default_account = "service-${var.oms_project_number}@dataproc-accounts.iam.gserviceaccount.com"
  compute_default_account  = "${var.oms_project_number}-compute@developer.gserviceaccount.com"
  dphs_bucket              = "${var.gcp_cloud_code}${lower(var.gcs_bucket_default_location)}-${var.gcp_gcs_code}${var.gcp_application_code}dphs-${var.gcp_environment_code}"

}

resource "google_project_iam_member" "dataproc_oms_sa_iam" {
  project = var.network_info.project
  role    = "roles/compute.networkUser"
  member  = "serviceAccount:${local.dataproc_default_account}"
}

resource "google_project_iam_member" "compute_oms_sa_iam" {
  project = var.network_info.project
  role    = "roles/compute.networkUser"
  member  = "serviceAccount:${local.compute_default_account}"
}

resource "google_compute_firewall" "allow_all_dataproc" {
  project     = var.network_info.project
  name        = "gc-fw-in-ips-${var.gcp_environment_code}-tag-oms-internal-allow"
  network     = var.network_info.vpc
  description = "Allow all internal communication within "

  source_ranges = [var.gcp_vpc_subnet_range]

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }
  target_tags = ["oms-internal"]
}

resource "google_dataproc_cluster" "oms_pricing_dataproc_cluster" {
  name                          = "${var.gcp_cloud_code}${var.gcp_primary_region_code}${var.gcp_dtpc_code}${var.gcp_application_code}${var.gcp_environment_code}${var.oms_dataproc_cluster.index_code}"
  region                        = var.gcp_primary_region
  project                       = var.oms_project_name
  graceful_decommission_timeout = "120s"
  labels                        = var.oms_dataproc_cluster.gcp_labels
  provider = google-beta

  cluster_config {
    master_config {
      num_instances = var.oms_dataproc_cluster.master_num_instances
      machine_type  = var.oms_dataproc_cluster.master_machine_type
      disk_config {
        boot_disk_type    = "pd-ssd"
        boot_disk_size_gb = var.oms_dataproc_cluster.master_disk_size
      }
    }

    gce_cluster_config {
      zone             = var.gcp_primary_zone
      internal_ip_only = true
      subnetwork       = "projects/${var.network_info.project}/regions/${var.gcp_primary_region}/subnetworks/${var.network_info.subnet}"
      tags             = ["oms-internal"]
    }

    software_config {
      image_version = "2.0.28-centos8"
      override_properties = {
        "dataproc:dataproc.allow.zero.workers"              = "true"
        "dataproc:job.history.to-gcs.enabled"               = "true"
        "spark:spark.history.fs.logDirectory"               = "gs://${local.dphs_bucket}/*/spark-job-history"
        "mapred:mapreduce.jobhistory.done-dir"              = "gs://${local.dphs_bucket}/*/mapreduce-job-history/done"
        "mapred:mapreduce.jobhistory.intermediate-done-dir" = "gs://${local.dphs_bucket}/*/mapreduce-job-history/intermediate-done"
        "mapred:mapreduce.jobhistory.read-only.dir-pattern" = "gs://${local.dphs_bucket}/*/mapreduce-job-history/done"
      }
    }

    endpoint_config {
      enable_http_port_access = "true"
    }
  }
}
