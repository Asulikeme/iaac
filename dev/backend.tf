terraform {
  backend "s3" {
    bucket = "statemgmt-terraform"
    key    = "dev/terraform.tfstate"
    region = "us-west-1"
  }
}
