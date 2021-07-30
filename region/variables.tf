variable "region" {
  description = "The name of the AWS region to set up a network within"
}

variable "base_cidr_block" {}

variable "name_prefix" {}

provider "aws" {
  region = var.region
}