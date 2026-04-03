variable "subnet_cidr_block" {
  description = "The CIDR block for the subnet"
  type        = list(string)
}

variable "subnet_name" {
  description = "The name tag for the subnet"
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC ID to associate subnets with"
  type        = string
}