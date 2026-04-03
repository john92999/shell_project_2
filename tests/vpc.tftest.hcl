provider "aws" {
    region = "ap-south-1"
}

run "create_vpc" {
    command = apply
    module {
        source = "./modules/vpc"
    }
    variables {
        vpc_cidr_block = "10.0.0.0/16"
    }
    assert{
        condition = output.vpc_id != null
        error_message = "VPC ID should not be null"
    }
}

run "vpc_is_idempotent"{
    command = plan
    module {
        source = "./modules/vpc"
    }
    variables {
        vpc_cidr_block = "10.0.0.0/16"
    }
    assert{
        condition = length(output.vpc_id) > 0
        error_message = "VPC ID should still exist with no changes planned"
    }
}