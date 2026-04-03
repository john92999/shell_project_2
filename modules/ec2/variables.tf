variable "vpc_id" {
  type = string
}

variable "sg_name" {
  type = list(string)
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "private_subnet_id" {
  type = string
}