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

variable roles_and_policy {
 type = list(map(string))
 default = [{ name = "lb"}] 
 }

 variable iam_policy_extra_vars {
  type = map(string)
}