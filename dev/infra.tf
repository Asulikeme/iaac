
provider "aws" {
  region = var.region_name
}

data "aws_availability_zones" "available" {
}

data "aws_security_group" "default" {
  name     = "default"
  vpc_id   = module.vpc-1.vpc_id
}

data "aws_caller_identity" "current" {
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
}

output "tls_private_key" {
  sensitive = true
  value = tls_private_key.this.private_key_pem
}


module "key_pair-1" {
  source = "../aws/keypair"

  key_name   = "${var.eks_cluster_name}-ssh-1"
  public_key = tls_private_key.this.public_key_openssh

  tags = {
    owner           = var.owner
    environment     = var.environment
    componnet       = "sshkeypair"
  }
}

module "vpc-1" {
  source               = "../aws/vpc"
  name                 = "${var.eks_cluster_name}-vpc-1"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  database_subnets     = ["10.0.200.0/24", "10.0.201.0/24", "10.0.202.0/24"]
  private_subnets      = ["10.0.96.0/19", "10.0.128.0/19", "10.0.160.0/19"]
  public_subnets       = ["10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  # VPC endpoint for S3
  enable_s3_endpoint = false

  # VPC endpoint for KMS
  enable_kms_endpoint              = false
  kms_endpoint_private_dns_enabled = false
  kms_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}-vpc-1" = "shared"
    "kubernetes.io/role/elb"                              = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}-vpc-1" = "shared"
    "kubernetes.io/role/internal-elb"                     = "1"
  }

  tags = {
    environment                                           = var.environment
    componnet                                             = "vpc"
    "kubernetes.io/cluster/${var.eks_cluster_name}-vpc-1" = "shared"
  }
}

variable "create_eks" {
  default = "true"
}

module "eks-1" {
  source                               = "../aws/eks"
  cluster_name                         = "${var.eks_cluster_name}-1"
  subnets                              = module.vpc-1.private_subnets
  cluster_version                      = var.eks_version
  /* cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"] */
  cluster_iam_role_name                = "${var.eks_cluster_name}-cluster-1"
  workers_role_name                    = "${var.eks_cluster_name}-worker-1"
  enable_irsa                          = true
  create_eks                           = true
  /* region                               = "us-west-2" */

  tags = {
    owner           = var.owner
    environment     = var.environment
    component       = "eks"
  }

  vpc_id                    = module.vpc-1.vpc_id
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  map_roles = [
    /* {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/eks-devuser"
      username = "eks-devuser"
      groups   = ["system:masters"]
    } */
  ]

  map_users = [
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/eks-devuser"
      username = "eks-devuser"
      groups   = ["system:masters"]
    }
  ]

  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 500
    # #  Needed to bring up node groups to same version as of master
    eks_node_groups_version = var.eks_version
  }

  node_groups = {
    web = {
      desired_capacity          = 3
      max_capacity              = 3
      min_capacity              = 3
      key_name                  = module.key_pair-1.this_key_pair_key_name
      source_security_group_ids = [module.eks_wg_sg.this_security_group_id]
      remote_access = {
        key_name = module.key_pair-1.this_key_pair_key_name
      }
      instance_type = "m5.xlarge"
      k8s_labels = {
        environment = var.environment
        node-role   = "web"
      }
      additional_tags = {
        ExtraTag              = "web",
        "key"                 = "k8s.io/cluster-autoscaler/enabled",
        "propagate_at_launch" = "false",
        "value"               = "true"
      }
    }

    
  }

}


output "eks_cluster_endpoint" {
  value = module.eks-1.cluster_endpoint
}


output "eks_cluster_oidc_issuer_url" {
  value = module.eks-1.cluster_oidc_issuer_url
}

output "eks_cluster_id" {
  value = module.eks-1.cluster_id
}

module "eks_wg_sg" {
  source = "../aws/sg"

  name        = "${var.eks_cluster_name}-wg-source-sg-1"
  description = "Security group for worker groups created in EKS"
  vpc_id      = module.vpc-1.vpc_id

  tags = {
    owner           = var.owner
    environment     = var.environment
    component       = "securitygroup"
    Name            = "${var.eks_cluster_name}-wg-source-sg-1"
  }

}

# Ingress for source security group created for worker group nodes
resource "aws_security_group_rule" "worker_group_source_sg_ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = module.eks_wg_sg.this_security_group_id
  cidr_blocks       = ["10.0.0.0/16"]
}


# Egress for source security group created for worker group node
resource "aws_security_group_rule" "worker_group_source_sg_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = module.eks_wg_sg.this_security_group_id
  cidr_blocks       = ["10.0.0.0/16"]
}

resource "aws_security_group_rule" "port1" {
  type              = "ingress"
  from_port         = 30080
  to_port           = 30080
  protocol          = "tcp"
  security_group_id = module.eks-1.cluster_security_group_id
  cidr_blocks       = ["10.0.0.0/16"]
}

locals {
  role_and_policy_name = [for i in var.roles_and_policy : "${var.cluster_name}-${i["name"]}"]
  iam_policy           = [for i in var.roles_and_policy : templatefile("${path.module}/policies/${i["name"]}.json.tftpl", var.iam_policy_extra_vars)]
}

module "iam_roles_with_oidc" {
  source = "../aws/oidc"

  create_role = true
  aws_partition = "aws"
  role_name = local.role_and_policy_name

  tags = {
    owner           = var.owner
    environment     = var.environment
    Name            = "${var.eks_cluster_name}-lb-role-1"
    component       = "iamrole"
  }

  provider_url = trimprefix(module.eks-1.eks_cluster_oidc_issuer_url, "https://")

}

output "iam_roles_arns" {
  value = module.iam_roles_with_oidc.this_iam_role_arn
}

output "iam_roles_names" {
  value = module.iam_roles_with_oidc.this_iam_role_name
}


