
resource "google_redis_instance" "cache" {
  name           = "private-cache"
  tier           = "STANDARD_HA"
  region         = var.region
  project        = var.prod_project
  memory_size_gb = 1


  location_id             = "us-east4-a"
  alternative_location_id = "us-east4-b"

  authorized_network = "projects/gc-proj-nw-shpr-df4e/global/networks/prod-core-sharedvpc"
  connect_mode       = "PRIVATE_SERVICE_ACCESS"

  redis_version = "REDIS_4_0"
  display_name  = "CSWG Test Instance"


  depends_on = [
    google_project_service.enable_memorystore_api
  ]


}
