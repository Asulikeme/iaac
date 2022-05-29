terraform {
  backend "gcs" {
    bucket = "tf-mgmt-marsmelon"
    prefix = "terraform/testing"
  }
}