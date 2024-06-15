module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = [for i in range(0, length(var.availability_zones)) : "${var.availability_zones[i]}"]
  public_subnets  = [for i in range(0, var.public_subnets_count) : cidrsubnet(var.vpc_cidr, 8, i)]
  private_subnets = []

  enable_nat_gateway = false
}
