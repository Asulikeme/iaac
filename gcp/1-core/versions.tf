terraform {
  required_version = ">= 0.15.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.45, < 4.0"
    }
  }
}

provider "google" {
  billing_project = "gc-proj-tf-pr-5401"
  user_project_override = true
}