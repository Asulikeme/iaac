resource "google_monitoring_notification_channel" "test_email" {
  display_name = "Test Notification Channel - mshafran"
  type         = "email"
  project      = var.nonprod_monitoring_project
  labels       = {
    email_address = "mshafran@cswg.com"
  }
}