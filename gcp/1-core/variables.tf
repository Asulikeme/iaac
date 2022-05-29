variable "gcp_project_id" {
    type = string
    description = "(optional) describe your variable"
}

variable "gcp_organization_id" {
  type = string
  description = "Organization ID expressed as a organizations/<org id>"
}

variable "gcp_cloud_code" {
    type = string
    description = "length upto 3 chars including the -.Cloud code will be gc- for GCP terraform"
    default = "gc-"
}

variable "gcp_resource_region" {
    type = string
    description = "Region where the resource will be created, the standard region code will be derived from this"
    default = "us-east4"
}

variable "gcp_billing_account" {
    type = string
    description = "(optional) describe your variable"
}

# Variables for the TF project

variable "gcp_proj_services_to_enable" {
  description = "List of services that should be enabled on the TF project"
  type = list(string)  
}

# Variables for the TF service account

variable "gcp_tf_svc_acc_org_iam_roles" {
  description = "List of permissions granted to Terraform service account across the GCP organization."
  type        = list(string)
}

