locals {
    app_code_dash = "${var.gcp_app_code}-"
    vpc_network    = var.gcp_environment_code == "prd" ? "gc-gbl-svpc-gke-shpr-01" : "gc-gbl-svpc-gke-shnp-01"
    pod_subnet      =  "${var.gcp_cloud_code}${var.gcp_primary_location_code}${var.gcp_gke_pod_code}${local.app_code_dash}${var.gcp_environment_code}"
    services_subnet =  "${var.gcp_cloud_code}${var.gcp_primary_location_code}${var.gcp_gke_services_code}${local.app_code_dash}${var.gcp_environment_code}"
   # master_subnet =  "${var.gcp_cloud_code}${var.gcp_primary_location_code}${var.gcp_gke_master_code}${local.app_code_dash}${var.gcp_environment_code}"
}

# ENABLE KMS API

resource "google_kms_crypto_key" "gke-kms-key" {
  name     = "${var.gcp_cloud_code}${var.gcp_kmek_code}${local.app_code_dash}${var.gcp_environment_code}"
  key_ring = "'projects/{{project}}/locations/{{location}}/keyRings/{{keyRing}}"
  purpose  = "ENCRYPT_DECRYPT"

  labels = var.cluster.labels

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_service_account" "gke-service-account" {
  project = var.project_name
  account_id = "${var.gcp_cloud_code}${var.gcp_svc_code}${local.app_code_dash}${var.gcp_environment_code}-k8"
}

resource "google_project_iam_member" "robot_container_permission" {
  project  = var.network_info.project
  role     = "roles/container.serviceAgent"
  member   = "serviceAccount:service-${var.project_number}@container-engine-robot.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "cloud_service_permission" {
  project  = var.network_info.project
  role     = "roles/compute.networkUser"
  member   = "serviceAccount:${var.project_number}@cloudservices.gserviceaccount.com"
}

resource "google_compute_subnetwork" "gke-subnetwork" {
  name                        = "${var.gcp_cloud_code}${var.gcp_primary_location_code}${var.gcp_subnet_code}${local.app_code_dash}${var.gcp_environment_code}"
  project                     = var.network_info.project
  ip_cidr_range               = var.gke_subnets.primary
  region                      = var.gcp_primary_region
  network                     = local.vpc_network
  private_ip_google_access    = true

  secondary_ip_range {
     range_name    = local.pod_subnet
     ip_cidr_range = var.gke_subnets.pods
  }

  secondary_ip_range {
    range_name    = local.services_subnet
    ip_cidr_range = var.gke_subnets.services
  }
}

resource "google_container_cluster" "gke" {
  name     = "${var.gcp_cloud_code}${var.gcp_gke_code}${local.app_code_dash}${var.gcp_environment_code}"
  location = var.gcp_primary_region
  project  = var.project_name
  resource_labels = var.cluster.labels
  enable_binary_authorization = true

  networking_mode = "VPC_NATIVE"
  network         = google_compute_subnetwork.gke-subnetwork.network
  subnetwork      = google_compute_subnetwork.gke-subnetwork.self_link
 
  remove_default_node_pool = true
  initial_node_count       = 1

  release_channel {
    channel = "REGULAR"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = local.pod_subnet
    services_secondary_range_name = local.services_subnet
  }

  network_policy {
    provider = "PROVIDER_UNSPECIFIED"
    enabled  = var.cluster.network_policy_enabled
  }

  workload_identity_config {
    workload_pool = "${var.project_name}.svc.id.goog"
  }

  private_cluster_config {
    enable_private_nodes = true
    enable_private_endpoint  = true
    master_ipv4_cidr_block = var.gke_subnets.master
  }

  master_authorized_networks_config {
    # Empty block makes it so nothing external can access master
  }

  cluster_autoscaling {
    enabled           = true
    resource_limits {
      resource_type = "cpu"
      minimum       = var.cluster.autoscale_cpu_minimum
      maximum       = var.cluster.autoscale_cpu_maximum
    }
    resource_limits {
      resource_type = "memory"
      minimum       = var.cluster.autoscale_mem_minimum
      maximum       = var.cluster.autoscale_mem_minimum
    } 
  }

  vertical_pod_autoscaling {
    enabled = true
  }

  maintenance_policy {
    recurring_window {
      start_time = "2022-03-24T${var.cluster.maintenance_start}Z"
      end_time      = "2022-03-24T${var.cluster.maintenance_end}Z"
      recurrence    = "FREQ=WEEKLY;BYDAY=${var.cluster.maintenance_days}"
    }
  }

  depends_on = [
    google_project_iam_member.cloud_service_permission,
    google_project_iam_member.robot_container_permission
  ]

}

resource "google_container_node_pool" "general" { 
  name       = "${var.gcp_cloud_code}${var.gcp_node_pool_code}${local.app_code_dash}${var.gcp_environment_code}"
  location   = var.gcp_primary_region
  cluster    = google_container_cluster.gke.name
  project    = var.project_name

  node_count = 1

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling{
    min_node_count = var.node.autoscale_min_count
    max_node_count = var.node.autoscale_max_count
  }

  node_config {

    machine_type    = var.node.machine_type
    disk_size_gb    = var.node.disk_size
    labels          = var.node.labels
    tags            = var.node.tags
    service_account = google_service_account.gke-service-account.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append"
    ]
    shielded_instance_config {
      enable_secure_boot = true
    }
  }
}
