resource "google_compute_resource_policy" "portal_snapshot_policy" {
  name   = "mosaic-snapshot-policy"
  project = trimprefix(module.mosaic_project.project_id, "projects/")
  region = var.gcp_primary_region
  snapshot_schedule_policy {
    schedule {
      hourly_schedule {
        hours_in_cycle = 20
        start_time     = "23:00"
      }
    }
    retention_policy {
      max_retention_days    = 10
      on_source_disk_delete = "APPLY_RETENTION_POLICY"
    }
    snapshot_properties {
      labels = {
        backup = "true"
      }
      storage_locations = ["us"]
      guest_flush       = false
    }
  }
}