variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "subnet_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks for subnets"
}

variable "subnet_names" {
  type        = list(string)
  description = "Names for subnets"
}