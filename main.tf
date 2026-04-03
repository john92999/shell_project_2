module "vpc" {
  source = "./modules/vpc"
  vpc_cidr_block = var.vpc_cidr_block
}

module "subnet" {
  source = "./modules/subnet"
  subnet_cidr_block = var.subnet_cidr_block
  subnet_name = var.subnet_name
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "subnet_cidr_block" {
  type        = list(string)
  description = "CIDR block for the subnet"
}

variable "subnet_name" {
  type        = list(string)
  description = "Name for the subnet"
}