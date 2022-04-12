variable "name" {
  description = "The name of the policy"
  type        = list(string)
  default     = []
}

# variable "name" {
#   description = "The name of the policy"
#   type        = string
#   default     = ""
# }
variable "aws_region" {}

variable "path" {
  description = "The path of the policy in IAM"
  type        = string
  default     = "/"
}

variable "description" {
  description = "The description of the policy"
  type        = string
  default     = "IAM Policy"
}

# variable "policy" {
#   description = "The path of the policy in IAM (tpl file)"
#   type        = string
#   default     = ""
# }
variable "policy" {
  description = "The path of the policy in IAM (tpl file)"
  type        = list(string)
  default     = []
}
