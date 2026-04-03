resource "aws_vpc" "main-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name = "main-vpc"
    }
}