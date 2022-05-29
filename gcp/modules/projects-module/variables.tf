variable "gcp_cloud_code" {
  type        = string
  description = "Code for GCP resources to use when naming or labeling resources"
  default = "gc-"
}


variable "gcp_project_code" {
  type        = string
  description = "Project Code"
  default = "proj-"
}


variable "gcp_env_code" {
  type        = string
  description = ""
}


variable "gcp_billing_account" {
  type        = string
  description = ""
  default = "011A30-FDDCC7-88861E"
}


variable "gcp_application_code" {
  type        = string
  description = ""
}


variable "parent_folder" {
  type        = string
  description = ""
}


variable "gcp_project_labels" {
  type        = map (string)
  description = ""
}


variable "gc_proj_standard_apis" {
  type        = list (string)
  description = ""
}


variable "network_info_project" {
  type        = string
  description = ""
}


# variable "gcp_grp_iam_roles" {
#   type        = string
#   description = ""
# }

variable "gcp_notification_recipients" {
    type = list(string)
    description = "list of email addresses to receive notifications"
}

variable "gcp_iam_permissions" {

    type = list(object(
        {iam_roles = list(string)
        group_email = string
        }
    
    ))

}


        