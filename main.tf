terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "remote" {
    organization = "tomasnar"

    workspaces {
      name = "tomasnar"
    }
  }
}

module "region_1" {
  source          = "./region"
  region          = var.region
  base_cidr_block = var.base_cidr_block
  name_prefix     = "test-network1"
}

# module "us-west-2" {
#   source          = "./region"
#   region          = "us-west-2"
#   base_cidr_block = var.base_cidr_block
# }

module "asg_1" {
  source = "./asg"
  name   = "test-instance1"
  vpc_id = module.region_1.vpc_id
}