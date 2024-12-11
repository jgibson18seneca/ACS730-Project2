
# Module to deploy basic networking 
module "vpc" {
  source = "../../../terraform"
  vpc_cidr           = var.vpc_cidr
  public_cidr_blocks = var.public_cidrs
  private_cidr_blocks = var.private_cidrs
  prefix             = var.prefix
}