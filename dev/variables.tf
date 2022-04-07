variable "environment" {
    default = "dev"
    type = string
}
variable "eks_cluster_name" {
    default = "dev"
    type = string
}
variable "region_name" {
    default = "us-west-1"
    type = string
}
variable "eks_version" {
    default = "1.20"
    type = string
}
variable "owner" {
    default = "ops"
}