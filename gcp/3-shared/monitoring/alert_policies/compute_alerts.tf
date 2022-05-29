resource "google_monitoring_alert_policy" "test_alert_policy" {
  project = var.nonprod_monitoring_project
  display_name = "Test Alert Policy"
  combiner     = "AND"
  conditions {
    display_name = "Disk space utilization is 80% or higher"
    condition_threshold {
      filter      = "metric.type=\"agent.googleapis.com/disk/percent_used\" AND resource.type=\"gce_instance\" AND metric.label.state=\"used\""
      duration   = "60s"
      comparison = "COMPARISON_GT"
      threshold_value = "80"
      trigger {
        count  = "5"
      }   
      aggregations {
        per_series_aligner = "ALIGN_NONE"
      }
    }
  }
  notification_channels = [
    google_monitoring_notification_channel.test_email.name
  ]
  documentation {
    content = "The disk space utilization on ${resource.label.name} has exceeded 80% for the device: ${metric.label.device}"
  }
}
