<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.5 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 3.45, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 3.75.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_networking_folder"></a> [networking\_folder](#module\_networking\_folder) | ../modules/folders | n/a |
| <a name="module_org_boolean_policies"></a> [org\_boolean\_policies](#module\_org\_boolean\_policies) | ../modules/org-policies | n/a |
| <a name="module_org_compute_vmExternalIpAccess_policy"></a> [org\_compute\_vmExternalIpAccess\_policy](#module\_org\_compute\_vmExternalIpAccess\_policy) | ../modules/org-policies | n/a |
| <a name="module_org_gcp_resourceLocations_policy"></a> [org\_gcp\_resourceLocations\_policy](#module\_org\_gcp\_resourceLocations\_policy) | ../modules/org-policies | n/a |
| <a name="module_org_level_folders"></a> [org\_level\_folders](#module\_org\_level\_folders) | ../modules/folders | n/a |

## Resources

| Name | Type |
|------|------|
| [google_organization_iam_member.group_billing_admins_org_iam](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/organization_iam_member) | resource |
| [google_organization_iam_member.group_org_admins_org_iam](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/organization_iam_member) | resource |
| [google_organization_iam_member.group_security_admins_org_iam](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/organization_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_excluded_folders_resloc_policy"></a> [excluded\_folders\_resloc\_policy](#input\_excluded\_folders\_resloc\_policy) | List of folders to be excluded from constraints/gcp.resourceLocations | `list(string)` | `[]` | no |
| <a name="input_excluded_folders_vmextip_policy"></a> [excluded\_folders\_vmextip\_policy](#input\_excluded\_folders\_vmextip\_policy) | List of folders to be excluded from constraints/compute.vmExternalIpAccess | `list(string)` | `[]` | no |
| <a name="input_gcp_group_billing_admins"></a> [gcp\_group\_billing\_admins](#input\_gcp\_group\_billing\_admins) | Google Group for GCP Billing Administrators | `string` | n/a | yes |
| <a name="input_gcp_group_billing_admins_org_iam_roles"></a> [gcp\_group\_billing\_admins\_org\_iam\_roles](#input\_gcp\_group\_billing\_admins\_org\_iam\_roles) | List of roles that will be assigned to the billing admin group | `list(string)` | n/a | yes |
| <a name="input_gcp_group_org_admins"></a> [gcp\_group\_org\_admins](#input\_gcp\_group\_org\_admins) | Google Group for GCP Organization Administrators | `string` | n/a | yes |
| <a name="input_gcp_group_org_admins_org_iam_roles"></a> [gcp\_group\_org\_admins\_org\_iam\_roles](#input\_gcp\_group\_org\_admins\_org\_iam\_roles) | List of roles that will be assigned to the org admin group | `list(string)` | n/a | yes |
| <a name="input_gcp_group_security_admins"></a> [gcp\_group\_security\_admins](#input\_gcp\_group\_security\_admins) | Google Group for GCP Security Administrators | `string` | n/a | yes |
| <a name="input_gcp_group_security_admins_org_iam_roles"></a> [gcp\_group\_security\_admins\_org\_iam\_roles](#input\_gcp\_group\_security\_admins\_org\_iam\_roles) | List of roles that will be assigned to the security admin group | `list(string)` | n/a | yes |
| <a name="input_gcp_org_boolean_policies_list"></a> [gcp\_org\_boolean\_policies\_list](#input\_gcp\_org\_boolean\_policies\_list) | This is a list of boolean policies that will be applied across the organization | `list(string)` | n/a | yes |
| <a name="input_gcp_org_level_folders"></a> [gcp\_org\_level\_folders](#input\_gcp\_org\_level\_folders) | This is a list of folders that will reside under the organization node (excluding core) | `list(string)` | n/a | yes |
| <a name="input_gcp_organization_id"></a> [gcp\_organization\_id](#input\_gcp\_organization\_id) | Organization ID expressed as a organizations/<org id> | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gcp_org_level_folder_map"></a> [gcp\_org\_level\_folder\_map](#output\_gcp\_org\_level\_folder\_map) | n/a |
<!-- END_TF_DOCS -->