module "vpc" {
  source = "./modules/vpc"
  vpc_cidr_block = var.vpc_cidr_block
}

module "subnet" {
  source = "./modules/subnet"
  subnet_cidr_block = var.subnet_cidr_blocks
  subnet_name = var.subnet_names
}