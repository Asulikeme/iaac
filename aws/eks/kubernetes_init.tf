data "aws_availability_zones" "available_tools" {
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = var.vpc_id
}


data "aws_eks_cluster" "cluster" {
  count = var.create_eks ? 1 : 0
  name  = element(concat(aws_eks_cluster.this.*.id, [""]), 0)
}

data "aws_eks_cluster_auth" "cluster" {
  count = var.create_eks ? 1 : 0
  name  = element(concat(aws_eks_cluster.this.*.id, [""]), 0)
}

/* data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.this[0].cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.this[0].cluster_id
} */

# In case of not creating the cluster, this will be an incompletely configured, unused provider, which poses no problem.
provider "kubernetes" {
  host                   = element(concat(data.aws_eks_cluster.cluster[*].endpoint, [""]), 0)
  cluster_ca_certificate = base64decode(element(concat(data.aws_eks_cluster.cluster[*].certificate_authority.0.data, [""]), 0))
  token                  = element(concat(data.aws_eks_cluster_auth.cluster[*].token, [""]), 0)
  /* host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token */
  /* load_config_file       = false */
}
