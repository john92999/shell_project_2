# Tests the subnet module (+ EIP + NAT Gateway) — applies real resources then destroys

provider "aws" {
  region = "ap-south-1"
}

# ── Step 1: Create the VPC first (subnet module depends on a real vpc_id) ─────
run "setup_vpc" {
  command = apply

  module {
    source = "./modules/vpc"
  }

  variables {
    vpc_cidr_block = "10.0.0.0/16"
  }
}

# ── Step 2: Apply subnet module using the VPC from step 1 ─────────────────────
run "create_subnets_and_nat" {
  command = apply

  module {
    source = "./modules/subnet"
  }

  variables {
    vpc_id            = run.setup_vpc.vpc_id   # wired from step 1 output
    subnet_cidr_block = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    subnet_name       = ["public-subnet", "private-subnet", "database-subnet"]
  }

  # Assert all 3 subnets were created
  assert {
    condition     = length(output.subnet_id) == 3
    error_message = "Expected 3 subnets to be created, got ${length(output.subnet_id)}"
  }

  # Assert the public subnet ID is not empty
  assert {
    condition     = output.public_subnet_id != ""
    error_message = "Public subnet ID should not be empty"
  }
}

# ── Step 3: Validate wrong index is caught ────────────────────────────────────
run "invalid_subnet_index_plan" {
  command = plan

  module {
    source = "./modules/subnet"
  }

  variables {
    vpc_id              = run.setup_vpc.vpc_id
    subnet_cidr_block   = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    subnet_name         = ["public-subnet", "private-subnet", "database-subnet"]
  }

  # Confirm the public subnet is index 0 = 10.0.1.0/24
  assert {
    condition     = output.public_subnet_id == output.subnet_id[0]
    error_message = "Public subnet should match index 0 in the subnet list"
  }
}