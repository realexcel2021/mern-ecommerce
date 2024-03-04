terraform {
  backend "s3" {
    bucket = "mern-ecommernce-tfstate"
    key    = "state/terraform.tfstate"
    region = "us-west-1"
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

  tags = var.tags
}

# get user identity

data "aws_caller_identity" "current" {}

# providers

data "aws_eks_cluster_auth" "this" {
  name = var.cluster_name
}
