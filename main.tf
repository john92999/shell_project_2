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
    subnet_id = module.subnet.subnet_id[0]
    tags = {
        Name = "main-nat-gw"
    }
    depends_on = [ aws_internet_gateway.main-igw ]
}

resource "aws_route_table" "public-route-table" {
    vpc_id = module.vpc.vpc_id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main-igw.id
    }
    tags = {
        Name = "public-route-table"
    }
}

resource "aws_route_table" "private-route-table" {
    vpc_id = module.vpc.vpc_id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.main-nat-gw.id
    }
    tags = {
        Name = "private-route-table"
    }
}

resource "aws_route_table_association" "public-subnet-association" {
    subnet_id = module.subnet.subnet_id[0]
    route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "private-subnet-association" {
    subnet_id = module.subnet.subnet_id[1]
    route_table_id = aws_route_table.private-route-table.id
}

resource "aws_route_table_association" "database-route-table-association" {
    subnet_id = module.subnet.subnet_id[2]
    route_table_id = aws_route_table.private-route-table.id  
}

module "ec2" {
    source = "./modules/ec2"
    vpc_id = module.vpc.vpc_id
    sg_name = var.sg_name
    ami_id = var.ami_id
    instance_type = var.instance_type
    public_subnet_id = module.subnet.subnet_id[0]
    private_subnet_id = module.subnet.subnet_id[1]
    key_name = var.key_name
}

module "eks" {
  source             = "./modules/eks"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = [module.subnet.subnet_id[1], module.subnet.subnet_id[2]]
  cluster_name       = var.cluster_name
  node_instance_type = var.instance_type
}

module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = [module.subnet.subnet_id[0]]   # add a 2nd public subnet for HA
}