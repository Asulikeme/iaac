terraform {
  required_version = ">= 0.13"
  required_providers {

    google = {
      source  = "hashicorp/google"
      version = "~> 3.53"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.53"
    }
  }

  provider_meta "google" {
    module_name = "blueprints/terraform/terraform-google-cloud-dns/v1.0.0"
  }

  provider_meta "google-beta" {
    module_name = "blueprints/terraform/terraform-google-cloud-dns/v1.0.0"
  }

}