locals {
  

  gcp_iam_permissions = flatten([ for iam_group_member in var.gcp_iam_permissions: 
              [ for iam_group_permission in iam_group_member.iam_roles:
              { "iam_group_name" = iam_group_member.group_email
                "role" = iam_group_permission
              }
              ]
            ])
  cloudteam_email = ["gcprequests@cswg.com"]
  recipient_list = "${concat(var.gcp_notification_recipients, local.cloudteam_email)}"
  app_code = upper(trimsuffix("${var.gcp_application_code}", "-"))


}


module "project" {
  source                = "../projects"
  name                  = "${var.gcp_cloud_code}${var.gcp_project_code}${var.gcp_application_code}${var.gcp_env_code}"
  billing_account       = var.gcp_billing_account
  random_suffix         = true
  folder_id             = var.parent_folder
  labels                = var.gcp_project_labels
  enforce_cis_standards = true
  services              = var.gc_proj_standard_apis
  auto_create_network   = false
}

resource "google_compute_shared_vpc_service_project" "shared_vpc" {
  host_project    = var.network_info_project
  service_project = trimprefix(module.project.project_id, "projects/")
}


resource "google_project_iam_member" "gcp_grp" {
  project  = trimprefix(module.project.project_id, "projects/")
  for_each = {for iam in local.gcp_iam_permissions : "${iam.iam_group_name}:${iam.role}" => iam  } 
  role     = each.value.role
  member   = "group:${each.value.iam_group_name}"
}
resource "google_billing_budget" "budget" {
  billing_account = var.gcp_billing_account
  display_name    = "${local.app_code} - POC Billing Budget"

  budget_filter {
    projects = [module.project.project_id]
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
    #monitoring_notification_channels = google_monitoring_notification_channel.gcp_notification_channel.*.id
    monitoring_notification_channels = [for notification_channel in google_monitoring_notification_channel.gcp_notification_channel : "${notification_channel.id}"]
    
    disable_default_iam_recipients = true
  }
}

resource "google_monitoring_notification_channel" "gcp_notification_channel" {
  project      = trimprefix(module.project.project_id, "projects/")
  display_name = "GCP Team Notification Channel"
  type         = "email"
  for_each = toset(local.recipient_list)
  #for_each = {for iam in local.recipient_list : "${iam.iam_group_name}:${iam.role}" => iam  }
  
  labels = {
    email_address = each.value
  }
}