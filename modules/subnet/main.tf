resource "aws_subnet" "main-subnet" {
    count = length(var.subnet_cidr_block)
    vpc_id = aws_vpc.main-vpc.id
    cidr_block = var.subnet_cidr_block[count.index]
    tags = {
        Name = var.subnet_name[count.index]
    }   
}