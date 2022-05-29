# 1. Assign the proper privileges to the starter groups at the organization level - 
# org admin, billing admin, security admin, network admin
# 1. Assign privileges to the starter groups at org level:
# For the org admin group
resource "google_organization_iam_member" "group_org_admins_org_iam" {
  for_each = toset(var.gcp_group_org_admins_org_iam_roles)
  org_id = trimprefix(var.gcp_organization_id, "organizations/")
  role   = each.value
  member = "group:${var.gcp_group_org_admins}"
}

#For the billing admin group
resource "google_organization_iam_member" "group_billing_admins_org_iam" {
  for_each = toset(var.gcp_group_billing_admins_org_iam_roles)
  org_id = trimprefix(var.gcp_organization_id, "organizations/")
  role   = each.value
  member = "group:${var.gcp_group_billing_admins}"
}

#For the security admin group
resource "google_organization_iam_member" "group_security_admins_org_iam" {
  for_each = toset(var.gcp_group_security_admins_org_iam_roles)
  org_id = trimprefix(var.gcp_organization_id, "organizations/")
  role   = each.value
  member = "group:${var.gcp_group_security_admins}"
}

#For all users
resource "google_organization_iam_member" "group_all_users_org_iam" {
  for_each = toset(var.gcp_group_all_users_org_iam_roles)
  org_id = trimprefix(var.gcp_organization_id, "organizations/")
  role   = each.value
  member = "group:${var.gcp_group_all_users}"
}
