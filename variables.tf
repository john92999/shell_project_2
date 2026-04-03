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

variable "sg_name" {
  type        = list(string)
  description = "Names for security groups"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "Instance type for EC2 instance"
}

variable "key_name" {
  type        = string
  description = "Key pair name for EC2 instance"
}

variable "cluster_name"{
    type        = string
    description = "Name of the EKS cluster"
}
