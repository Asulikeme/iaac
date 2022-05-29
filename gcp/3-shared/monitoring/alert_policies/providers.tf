provider "google" {
    project     = var.nonprod_monitoring_project
    region      = var.region
}

provider "google-beta" {
    project     = var.nonprod_monitoring_project
    region      = var.region
}