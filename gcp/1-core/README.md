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
| <a name="module_core_folder"></a> [core\_folder](#module\_core\_folder) | ../modules/folders | n/a |
| <a name="module_terraform_bucket"></a> [terraform\_bucket](#module\_terraform\_bucket) | ../modules/google-cloud-storage | n/a |
| <a name="module_terraform_project"></a> [terraform\_project](#module\_terraform\_project) | ../modules/projects | n/a |
| <a name="module_terraform_service_account"></a> [terraform\_service\_account](#module\_terraform\_service\_account) | ../modules/service-accounts | n/a |

## Resources

| Name | Type |
|------|------|
| [google_organization_iam_member.tf_sa_org_perms](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/organization_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gcp_billing_account"></a> [gcp\_billing\_account](#input\_gcp\_billing\_account) | (optional) describe your variable | `string` | n/a | yes |
| <a name="input_gcp_cloud_code"></a> [gcp\_cloud\_code](#input\_gcp\_cloud\_code) | length upto 3 chars including the -.Cloud code will be gc- for GCP terraform | `string` | `"gc-"` | no |
| <a name="input_gcp_organization_id"></a> [gcp\_organization\_id](#input\_gcp\_organization\_id) | Organization ID expressed as a organizations/<org id> | `string` | n/a | yes |
| <a name="input_gcp_proj_services_to_enable"></a> [gcp\_proj\_services\_to\_enable](#input\_gcp\_proj\_services\_to\_enable) | List of services that should be enabled on the TF project | `list(string)` | n/a | yes |
| <a name="input_gcp_project_id"></a> [gcp\_project\_id](#input\_gcp\_project\_id) | (optional) describe your variable | `string` | n/a | yes |
| <a name="input_gcp_resource_region"></a> [gcp\_resource\_region](#input\_gcp\_resource\_region) | Region where the resource will be created, the standard region code will be derived from this | `string` | `"us-east4"` | no |
| <a name="input_gcp_tf_svc_acc_org_iam_roles"></a> [gcp\_tf\_svc\_acc\_org\_iam\_roles](#input\_gcp\_tf\_svc\_acc\_org\_iam\_roles) | List of permissions granted to Terraform service account across the GCP organization. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gcp_core_folder_id"></a> [gcp\_core\_folder\_id](#output\_gcp\_core\_folder\_id) | n/a |
| <a name="output_gcp_terraform_project_id"></a> [gcp\_terraform\_project\_id](#output\_gcp\_terraform\_project\_id) | n/a |
| <a name="output_gcp_terraform_service_account_email"></a> [gcp\_terraform\_service\_account\_email](#output\_gcp\_terraform\_service\_account\_email) | n/a |
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
| <a name="module_core_folder"></a> [core\_folder](#module\_core\_folder) | ../modules/folders | n/a |
| <a name="module_terraform_bucket"></a> [terraform\_bucket](#module\_terraform\_bucket) | ../modules/google-cloud-storage | n/a |
| <a name="module_terraform_project"></a> [terraform\_project](#module\_terraform\_project) | ../modules/projects | n/a |
| <a name="module_terraform_service_account"></a> [terraform\_service\_account](#module\_terraform\_service\_account) | ../modules/service-accounts | n/a |

## Resources

| Name | Type |
|------|------|
| [google_organization_iam_member.tf_sa_org_perms](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/organization_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gcp_billing_account"></a> [gcp\_billing\_account](#input\_gcp\_billing\_account) | (optional) describe your variable | `string` | n/a | yes |
| <a name="input_gcp_cloud_code"></a> [gcp\_cloud\_code](#input\_gcp\_cloud\_code) | length upto 3 chars including the -.Cloud code will be gc- for GCP terraform | `string` | `"gc-"` | no |
| <a name="input_gcp_organization_id"></a> [gcp\_organization\_id](#input\_gcp\_organization\_id) | Organization ID expressed as a organizations/<org id> | `string` | n/a | yes |
| <a name="input_gcp_proj_services_to_enable"></a> [gcp\_proj\_services\_to\_enable](#input\_gcp\_proj\_services\_to\_enable) | List of services that should be enabled on the TF project | `list(string)` | n/a | yes |
| <a name="input_gcp_project_id"></a> [gcp\_project\_id](#input\_gcp\_project\_id) | (optional) describe your variable | `string` | n/a | yes |
| <a name="input_gcp_resource_region"></a> [gcp\_resource\_region](#input\_gcp\_resource\_region) | Region where the resource will be created, the standard region code will be derived from this | `string` | `"us-east4"` | no |
| <a name="input_gcp_tf_svc_acc_org_iam_roles"></a> [gcp\_tf\_svc\_acc\_org\_iam\_roles](#input\_gcp\_tf\_svc\_acc\_org\_iam\_roles) | List of permissions granted to Terraform service account across the GCP organization. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gcp_core_folder_id"></a> [gcp\_core\_folder\_id](#output\_gcp\_core\_folder\_id) | n/a |
| <a name="output_gcp_terraform_bucket"></a> [gcp\_terraform\_bucket](#output\_gcp\_terraform\_bucket) | n/a |
| <a name="output_gcp_terraform_project_id"></a> [gcp\_terraform\_project\_id](#output\_gcp\_terraform\_project\_id) | n/a |
| <a name="output_gcp_terraform_service_account_email"></a> [gcp\_terraform\_service\_account\_email](#output\_gcp\_terraform\_service\_account\_email) | n/a |
<!-- END_TF_DOCS -->