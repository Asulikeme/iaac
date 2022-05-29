# Create SQL instance
resource "google_sql_database_instance" "portal_psql_instance" {
  provider = google-beta

  name             = "${var.gcp_cloud_code}${var.gcp_primary_region_code}${var.gcp_psql_code}${var.gcp_application_code}${var.gcp_environment_code}${var.portal_sql_instance.index_code}"
  region           = var.gcp_primary_region
  project          = var.portal_project_name
  database_version = "POSTGRES_13"

  settings {
    tier              = var.portal_sql_instance.tier
    availability_type = var.portal_sql_instance.availability_type
    disk_size         = var.portal_sql_instance.size  
    disk_type         = "PD_SSD"
    disk_autoresize   = true
    user_labels       = var.portal_sql_instance.gcp_labels
    location_preference {
      zone            = var.gcp_primary_zone 
    }
    ip_configuration {
      ipv4_enabled    = false
      private_network = "projects/${var.network_info.project}/global/networks/${var.network_info.vpc}"
      #require_ssl     = true
    }

    insights_config {
      query_insights_enabled = true
    }
    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
      transaction_log_retention_days = "7"
      start_time                     = "23:00"
      location                       = "us"
      backup_retention_settings {
        retained_backups = "7"
      }
    }
    maintenance_window {
      day  = 7
      hour = 23
    }
  }
}

resource "google_dns_record_set" "sql_dns" {
  name         = "${google_sql_database_instance.portal_psql_instance.id}.${var.gcp_dns_suffix}."
  managed_zone = "${var.gcp_dns_zone}"
  project      = "${var.gcp_dns_project}"
  type         = "A"
  ttl          = 300
  rrdatas = ["${google_sql_database_instance.portal_psql_instance.private_ip_address}"]
}