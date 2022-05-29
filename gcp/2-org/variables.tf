variable "gcp_organization_id" {
  type = string
  description = "Organization ID expressed as a organizations/<org id>"
}

# Variables for org policies
variable "gcp_org_boolean_policies_list" {
  type = list(string)
  description = "This is a list of boolean policies that will be applied across the organization"
}

# Variables for org structure
variable "gcp_org_level_folders" {
  type = list(string)
  description = "This is a list of folders that will reside under the organization node (excluding core)"
}

# Variables for group names and associated IAM
variable "gcp_group_org_admins" {
  description = "Google Group for GCP Organization Administrators"
  type        = string
}

variable "gcp_group_org_admins_org_iam_roles" {
    type = list(string)
    description = "List of roles that will be assigned to the org admin group"
}

variable "gcp_group_billing_admins" {
  description = "Google Group for GCP Billing Administrators"
  type        = string
}

variable "gcp_group_billing_admins_org_iam_roles" {
    type = list(string)
    description = "List of roles that will be assigned to the billing admin group"
}

variable "gcp_group_security_admins" {
  description = "Google Group for GCP Security Administrators"
  type        = string
}

variable "gcp_group_security_admins_org_iam_roles" {
    type = list(string)
    description = "List of roles that will be assigned to the security admin group"
}

variable "gcp_group_all_users" {
  description = "Google Group for all users"
  type        = string
}

variable "gcp_group_all_users_org_iam_roles" {
    type = list(string)
    description = "List of roles that will be assigned to all users"
}

variable "excluded_folders_resloc_policy" {
  type = list(string)
  description = "List of folders to be excluded from constraints/gcp.resourceLocations"
  default = []
}

variable "excluded_folders_vmextip_policy" {
  type = list(string)
  description = "List of folders to be excluded from constraints/compute.vmExternalIpAccess"
  default = []
}