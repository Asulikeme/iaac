resource "google_redis_instance" "cache" {
  name           = "${var.gcp_cloud_code}${var.gcp_primary_region_code}${var.gcp_memorystore_redis_code}${var.gcp_application_code}${var.gcp_environment_code}${var.portal_sql_instance.index_code}"
  tier           = var.portal_redis_instance.tier
  region         = var.gcp_primary_region
  project        = var.portal_project_name
  memory_size_gb = var.portal_redis_instance.size


  location_id             = var.gcp_primary_zone
  alternative_location_id = "us-east4-a"

  authorized_network = "projects/${var.network_info.project}/global/networks/${var.network_info.vpc}"
  connect_mode       = "PRIVATE_SERVICE_ACCESS"

  redis_version = "REDIS_5_0"
  display_name  = "${var.gcp_cloud_code}${var.gcp_primary_region_code}${var.gcp_memorystore_redis_code}${var.gcp_application_code}${var.gcp_environment_code}${var.portal_sql_instance.index_code}"

  redis_configs = {
    notify-keyspace-events = "Elg"
  }

}

resource "google_dns_record_set" "memorystore_dns" {
  name         = "${google_redis_instance.cache.display_name}.${var.gcp_dns_suffix}."
  managed_zone = "${var.gcp_dns_zone}"
  project      = "${var.gcp_dns_project}"
  type         = "A"
  ttl          = 300
  rrdatas = ["${google_redis_instance.cache.host}"]
}