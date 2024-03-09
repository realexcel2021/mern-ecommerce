terraform {
  backend "s3" {
    bucket = "mern-ecommernce-tfstate-2"
    key    = "state/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.region
}

data "aws_eks_cluster" "example" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "auth" {
  name = module.eks.cluster_name
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.auth.token
  }
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.project_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = var.tags
}

# get user identity

data "aws_caller_identity" "current" {}

# providers
