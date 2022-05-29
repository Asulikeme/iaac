module "org_level_folders" {
  source = "../modules/folders"
  parent = var.gcp_organization_id
  names = var.gcp_org_level_folders
  set_roles = false
}

module "networking_folder" {
    source = "../modules/folders"
    parent = module.org_level_folders.ids["shared"]
    names = ["networking"]
    set_roles = false
}

module "monitoring_folder" {
    source = "../modules/folders"
    parent = module.org_level_folders.ids["shared"]
    names = ["monitoring"]
    set_roles = false
}