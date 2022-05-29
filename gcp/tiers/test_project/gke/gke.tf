locals {
    app_code = "abcd"
    gcp_labels = {
            "org": "cswg",
            "env": "dev",
            "cost-center": "is310",
            "app-code": "temp",
            "department": "is",
            "bucket-name": "na",
            "backup": "7_day",
            "created-by": "terraform",
            "owner-maintainer": "cloud-team",
            "primary-app-owner": "cloud-team",
            "maintenance-window": "sat_11pm",
            "os": "k8"
        }
    primary = "10.225.4.0/24"
    pods = "10.225.0.0/22"
    services = "10.225.5.0/24"
    master   = "10.255.6.0/28"
    test_project_number = "140432370258"
}

module "testing_gke_module"{
    source               = "../../../modules/gke"
    project_name         = var.test_project_name
    project_number       = local.test_project_number
    gcp_app_code         = local.app_code
    gcp_environment_code = var.gcp_environment_code
    cluster              = {
        network_policy_enabled = true
        autoscale_cpu_minimum      = 4
        autoscale_cpu_maximum      = 10
        autoscale_mem_minimum      = 4
        autoscale_mem_maximum      = 10
        labels                     = local.gcp_labels
        maintenance_start          = "05:00:00"
        maintenance_end            = "11:00:00"
        maintenance_days           = "FR,SA,SU"
        # MO, TU, WE, TH, FR, SA, and SU --- make sure to document this later
    }
    gke_subnets = {
        primary  = local.primary
        pods     = local.pods
        services = local.services
        master   = local.master
    }
    node = {
        machine_type = "e2-medium"
        autoscale_max_count    = 3
        autoscale_min_count    = 1
        disk_size    = 10
        labels       = local.gcp_labels
        tags         = [""]

    }
    network_info = {
        project     = var.network_info.project
        dns_zone    = var.gcp_dns_zone
        dns_suffix  = var.gcp_dns_suffix
        dns_project = var.gcp_dns_project
    }
}