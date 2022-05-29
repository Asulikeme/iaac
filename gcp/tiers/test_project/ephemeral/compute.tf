locals{
    app_code = "abcd"
    test_compute_instances = {
        "count": 2,
        "machine_type": "e2-standard-4",
        "firewall_tags": ["allow-ssh", "allow-icmp"],
        "boot_disk": "gc-proj-art-pr-06b5/cswg-base-centos7-image-1634823398",
        "gcp_labels": {
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
            "os": "centos"
        }
    }
}

module "testing_compute_module"{
    source       = "../../../modules/compute-instance"
    project_name = var.test_project_name
    gcp_app_code = local.app_code
    gcp_environment_code = var.gcp_environment_code
    compute_instances = {
        count         = local.test_compute_instances.count
        machine_type  = local.test_compute_instances.machine_type
        firewall_tags = local.test_compute_instances.firewall_tags
        boot_disk     = local.test_compute_instances.boot_disk
        gcp_labels    = local.test_compute_instances.gcp_labels
        gcp_os_code   = "cos"
        gcp_type_code = "app"
        disk_type     = "pd-ssd"
        disk_size     = 10
    }
    network_info = {
        project     = var.network_info.project
        vpc         = var.network_info.vpc
        subnet      = var.network_info.subnet
        dns_zone    = var.gcp_dns_zone
        dns_suffix  = var.gcp_dns_suffix
        dns_project = var.gcp_dns_project
    }
    http_lb = {
        lb_type        = "none"
        backend_port  = 443
        request_path  = "/status"
    }
}

