locals {
  gcp_application_code = "devis-"
  gcp_devis_grp = "dev_isbd_team@cswg.com"
  gcp_devis_grp_iam_roles = [       
        "roles/owner"
   ]
  gcp_devis_project_object = {
        gcp_random_suffix = true
        gcp_enforce_cis_standards = true
        gcp_labels = {
            org = "cswg"
            env = "poc"
            cost-center = "is310"
            app-code = "devis"
            department = "is"
            bucket-name = "na"
            backup = "na"
            created-by = "terraform"
            owner-maintainer = "cloud-team"
            primary-app-owner = "dev_isbd_team"
            maintenance-window = "na"
            os = "na"
        }
  }
}

module "devis_project" {
  source                = "../../modules/projects"
  name                  = "${var.gcp_cloud_code}${var.gcp_project_code}${local.gcp_application_code}${var.gcp_env_code}"
  billing_account       = var.gcp_billing_account
  random_suffix         = local.gcp_devis_project_object.gcp_random_suffix
  folder_id             = var.parent_folder
  labels                = local.gcp_devisproject_object.gcp_labels
  enforce_cis_standards = local.gcp_devis_project_object.gcp_enforce_cis_standards
  services              = var.gc_proj_standard_apis
  auto_create_network   = false
}

resource "google_compute_shared_vpc_service_project" "shared_vpc" {
  host_project    = var.network_info.project
  service_project = trimprefix(module.devis_project.project_id, "projects/")
}

resource "google_project_iam_member" "gcp_devis_grp" {
  project  = trimprefix(module.devis_project.project_id, "projects/")
  for_each = toset(local.gcp_devis_grp_iam_roles)
  role     = each.value
  member   = "group:${local.gcp_devis_grp}"
}
resource "google_billing_budget" "budget" {
  billing_account = var.gcp_billing_account
  display_name    = "DEVIS POC Billing Budget"

  budget_filter {
    projects = [module.devis_project.project_id]
  }

  amount {
    specified_amount {
      currency_code = "USD"
      units         = "5000"
    }
  }

  threshold_rules {
    threshold_percent = 0.2
  }
  threshold_rules {
    threshold_percent = 1.0
    spend_basis       = "FORECASTED_SPEND"
  }

  all_updates_rule {
    monitoring_notification_channels = [
      google_monitoring_notification_channel.gcp_notification_channel.id,
    ]
    disable_default_iam_recipients = true
  }
}

resource "google_monitoring_notification_channel" "gcp_notification_channel" {
  display_name = "GCP Team Notification Channel"
  type         = "email"

  labels = {
    email_address = "gcprequests@cswg.com"
  }
}