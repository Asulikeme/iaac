provider "google" {
    project     = var.monitoring_project
    region      = var.region
}

provider "google-beta" {
    project     = var.monitoring_project
    region      = var.region
}