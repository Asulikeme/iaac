# The script will setup the central networking projects that will be utilized by various applications

locals {

  # Note about label keys and values: 
  #   The key must start with a lowercase character, 
  #   can only contain lowercase letters, numeric characters, underscores and dashes. 
  #   The key can be at most 63 characters long.

}

resource "google_project_service" "enable_cloudsql_api" {
  project = var.prod_project
  service = "sqladmin.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}

resource "google_project_service" "enable_memorystore_api" {
  project = var.prod_project
  service = "redis.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}
