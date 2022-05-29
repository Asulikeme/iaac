locals {
  dataproc_default_account = "service-${var.omsp_project_number}@dataproc-accounts.iam.gserviceaccount.com"
  compute_default_account  = "${var.omsp_project_number}-compute@developer.gserviceaccount.com"
}

resource "google_project_iam_member" "dataproc_oms_sa_iam" {
  project  = var.network_info.project
  role     = "roles/compute.networkUser"
  member   = "serviceAccount:${local.dataproc_default_account}"
}

resource "google_project_iam_member" "compute_oms_sa_iam" {
  project  = var.network_info.project
  role     = "roles/compute.networkUser"
  member   = "serviceAccount:${local.compute_default_account}"
}

resource "google_compute_firewall" "allow_all_dataproc" {
  project     = var.network_info.project
  name        = "gc-fw-in-ips-nonprod-tag-omsp-internal-allow"
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
  target_tags = ["omsp-internal"]
}

resource "google_dataproc_cluster" "oms_pricing_dataproc_cluster" {
  name     = "${var.gcp_cloud_code}${var.gcp_primary_region_code}${var.gcp_dtpc_code}${var.gcp_application_code}${var.gcp_environment_code}${var.omsp_dataproc_cluster.index_code}"
  region   = var.gcp_primary_region
  project  = var.omsp_project_name
  graceful_decommission_timeout = "120s"
  labels = var.omsp_dataproc_cluster.gcp_labels

  cluster_config {
    master_config {
        num_instances = var.omsp_dataproc_cluster.master_num_instances
        machine_type  = var.omsp_dataproc_cluster.master_machine_type
        disk_config {
            boot_disk_type    = "pd-ssd"
            boot_disk_size_gb = var.omsp_dataproc_cluster.master_disk_size
        }
    }

    worker_config {
        num_instances    = var.omsp_dataproc_cluster.worker_num_instances
        machine_type     = var.omsp_dataproc_cluster.worker_machine_type
        disk_config {
            boot_disk_size_gb = var.omsp_dataproc_cluster.worker_disk_size
        }
    }

    gce_cluster_config {
        zone             = var.gcp_primary_zone 
        internal_ip_only = true
        subnetwork       = "projects/${var.network_info.project}/regions/${var.gcp_primary_region}/subnetworks/${var.network_info.subnet}"
        tags             = [ "omsp-internal" ]
    }

    software_config {
      image_version = "2.0.28-centos8"
    }
  }
}