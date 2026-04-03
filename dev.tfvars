vpc_cidr_block = "10.0.0.0/16"

subnet_cidr_blocks = [
  "10.0.1.0/24",
  "10.0.2.0/24",
  "10.0.3.0/24"
]

subnet_names = [
  "public-subnet",
  "private-subnet",
  "database-subnet"
]

sg_name = [ "bastion-sg", "app-sg" ]

ami_id = "ami-00bb6a80f01f03502"

instance_type = "t2.micro"

key_name = "demoapp.pem"

cluster_name  = "main-eks-cluster"
