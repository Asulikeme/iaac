
resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "instance" {
  provider = google-beta

  name             = "private-instance-${random_id.db_name_suffix.hex}"
  region           = var.region
  project          = var.prod_project
  database_version = "POSTGRES_13"

  depends_on = [
    google_project_service.enable_cloudsql_api
  ]

  settings {
    tier              = "db-f1-micro"
    availability_type = "REGIONAL"
    disk_type         = "PD_SSD"
    disk_autoresize   = true
    ip_configuration {
      ipv4_enabled    = false
      private_network = "projects/gc-proj-nw-shpr-df4e/global/networks/prod-core-sharedvpc"
    }
    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
      transaction_log_retention_days = "7"
      backup_retention_settings {
        retained_backups = "7"
      }
    }
  }
}
