variable "region" {
    type = string
    default = "us-east4"
}

variable "nonprod_monitoring_project" {
    type = string
    default = "gc-proj-mon-shnp-4763"
}
variable "prod_monitoring_project" {
    type = string
    default = "gc-proj-mon-shnp-4763"
}

variable "monitoring_projects" {
    type = list(string)
    default = ["gc-proj-mon-shnp-4763", "gc-proj-mon-shnp-4763"]
}