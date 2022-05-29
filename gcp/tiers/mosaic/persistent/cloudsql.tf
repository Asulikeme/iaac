# Postgres instance
resource "google_sql_database_instance" "mosaic_psql_instance" {
  provider = google-beta

  name             = "${var.gcp_cloud_code}${var.gcp_primary_region_code}${var.gcp_psql_code}${var.gcp_application_code}${var.gcp_environment_code}${var.mosaic_psql_instance.index_code}"
  region           = var.gcp_primary_region
  project          = var.mosaic_project_name
  database_version = "POSTGRES_13"

  settings {
    tier              = var.mosaic_psql_instance.tier
    availability_type = var.mosaic_psql_instance.availability_type
    disk_size         = var.mosaic_psql_instance.size  
    disk_type         = "PD_SSD"
    disk_autoresize   = true
    location_preference {
      zone            = var.gcp_primary_zone 
    }
    ip_configuration {
      ipv4_enabled    = false
      private_network = "projects/${var.network_info.project}/global/networks/${var.network_info.vpc}"
      require_ssl = true
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

resource "google_dns_record_set" "psql_dns" {
  name         = "${google_sql_database_instance.mosaic_psql_instance.id}.${var.gcp_dns_suffix}."
  managed_zone = "${var.gcp_dns_zone}"
  project      = "${var.gcp_dns_project}"
  type         = "A"
  ttl          = 300
  rrdatas = ["${google_sql_database_instance.mosaic_psql_instance.private_ip_address}"]
}


# MySQL Instance
resource "google_sql_database_instance" "mosaic_msql_instance" {
  provider = google-beta

  name             = "${var.gcp_cloud_code}${var.gcp_primary_region_code}${var.gcp_msql_code}${var.gcp_application_code}${var.gcp_environment_code}${var.mosaic_msql_instance.index_code}"
  region           = var.gcp_primary_region
  project          = var.mosaic_project_name
  database_version = "MYSQL_8_0"

  settings {
    tier              = var.mosaic_msql_instance.tier
    availability_type = var.mosaic_msql_instance.availability_type
    disk_size         = var.mosaic_msql_instance.size  
    disk_type         = "PD_SSD"
    disk_autoresize   = true
    location_preference {
      zone            = var.gcp_primary_zone 
    }
    ip_configuration {
      ipv4_enabled    = false
      private_network = "projects/${var.network_info.project}/global/networks/${var.network_info.vpc}"
      require_ssl = true
    }

   
    backup_configuration {
      enabled                        = true
      binary_log_enabled = true
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

resource "google_dns_record_set" "msql_dns" {
  name         = "${google_sql_database_instance.mosaic_msql_instance.id}.${var.gcp_dns_suffix}."
  managed_zone = "${var.gcp_dns_zone}"
  project      = "${var.gcp_dns_project}"
  type         = "A"
  ttl          = 300
  rrdatas = ["${google_sql_database_instance.mosaic_msql_instance.private_ip_address}"]
}