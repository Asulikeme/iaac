module "org_boolean_policies" {
  source            = "../modules/org-policies"
  for_each = toset(var.gcp_org_boolean_policies_list)

  constraint        = each.value
  policy_type       = "boolean"
  organization_id   = trimprefix(var.gcp_organization_id,"organizations/")
  enforce           = true
  policy_for = "organization"
}


module "org_compute_vmExternalIpAccess_policy" {
  source = "../modules/org-policies"
  constraint = "constraints/compute.vmExternalIpAccess"
  policy_type = "list"
  organization_id   = trimprefix(var.gcp_organization_id,"organizations/")
  enforce = true
  policy_for = "organization"
  # deny = [ "all"]  <- Uncomment this if there are specific values that need to be denied.
  # deny_list_length = 1 <- Explicitly set the count of the elements in the "deny" list, do not compute using the length function
  exclude_folders = var.excluded_folders_vmextip_policy 
}

module "org_gcp_resourceLocations_policy" {
  source = "../modules/org-policies"
  constraint = "constraints/gcp.resourceLocations"
  policy_type = "list"
  organization_id   = trimprefix(var.gcp_organization_id,"organizations/")
  # enforce = false <- Uncomment this if the policy needs to be denied.
  policy_for = "organization"
  allow = ["in:us-locations"]
  allow_list_length = 1
  exclude_folders = var.excluded_folders_resloc_policy 
}