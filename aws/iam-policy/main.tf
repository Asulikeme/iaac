resource "aws_iam_policy" "policy" {
  count       = length(var.policy)
  name        = var.name[count.index]
  path        = var.path
  description = var.description

  policy = var.policy[count.index]
}
