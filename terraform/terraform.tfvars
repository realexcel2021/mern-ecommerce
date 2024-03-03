project_name = "ecommerce-project"

azs = ["us-west-1a", "us-west-1b"]

private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

public_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

tags = {
  Environment  = "prod"
  project_name = "ecommerce-app"
  Terraform    = "true"
}

region = "eu-west-1"
