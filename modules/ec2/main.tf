resource "aws_security_group" "bastion_app_sg" {
    count = length(var.sg_name)
    name = var.sg_name[count.index]
    vpc_id = var.vpc_id
    dynamic ingress {
        for_each = local.bastion_ingress_rules
        content {
            from_port = ingress.value.from_port
            to_port = ingress.value.to_port
            protocol = ingress.value.protocol
            cidr_blocks = ingress.value.cidr_blocks
        }
    }
    dynamic egress {
        for_each = local.bastion_egress_rules
        content {
            from_port = egress.value.from_port
            to_port = egress.value.to_port
            protocol = egress.value.protocol
            cidr_blocks = egress.value.cidr_blocks
        }
    }
    tags = {
        count = length(var.sg_name)
        Name = var.sg_name[count.index]
    }
}

resource "aws_iam_role" "app-ec2-role" {
    name = "app-ec2-ecr-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
                Action = "sts:AssumeRole"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "ecr-readonly" {
    role = aws_iam_role.app-ec2-role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly" 
}

resource "aws_iam_instance_profile" "app-ec2-profile" {
    name = "app-ec2-profile"
    role = aws_iam_role.app-ec2-role.name
}

resource "aws_instance" "bastion" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = var.public_subnet_id
    vpc_security_group_ids  = [aws_security_group.bastion_app_sg[0].id]
    associate_public_ip_address = true
    key_name = var.key_name
    tags = {
        Name = "bastion-host"
    }
}

resource "aws_instance" "app-server" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = var.private_subnet_id
    vpc_security_group_ids  = [aws_security_group.bastion_app_sg[1].id]
    associate_public_ip_address = false
    iam_instance_profile = aws_iam_instance_profile.app-ec2-profile.name
    key_name = var.key_name
    tags = {
        Name = "app-server"
    }
}
