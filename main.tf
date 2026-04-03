module "vpc" {
  source = "./modules/vpc"
  vpc_cidr_block = var.vpc_cidr_block
}

module "subnet" {
  source = "./modules/subnet"
  vpc_id = module.vpc.vpc_id
  subnet_cidr_block = var.subnet_cidr_blocks
  subnet_name = var.subnet_names
}

resource "aws_internet_gateway" "main-igw" {
    vpc_id = module.vpc.vpc_id
    tags = {
        Name = "main-igw"
    }
}

resource "aws_eip" "nat-eip" {
  domain = "vpc"
    tags = {
        Name = "nat-eip"
    }
}


resource "aws_nat_gateway" "main-nat-gw" {
    allocation_id = aws_eip.nat-eip.id
    subnet_id = module.subnet.subnet_id[1]
    tags = {
        Name = "main-nat-gw"
    }
    depends_on = [ aws_eip.nat-eip ]
}