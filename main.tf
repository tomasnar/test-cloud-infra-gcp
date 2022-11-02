locals {
  project_id = "tomasnar-test-terraform"
  region = "asia-southeast1"
}

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
  cloud {
    organization = "tomasnar"
    workspaces {
      name = "tomasnar-gcp"
    }
  }
}

provider "google" {
  project     = local.project_id
  region      = local.region
}

module "vpc" {
    source  = "terraform-google-modules/network/google"
    version = "~> 4.0"

    network_name = "perkunas-vpc"
    routing_mode = "REGIONAL"
    project_id = local.project_id

    subnets = [
        {
            subnet_name           = "subnet-01"
            subnet_ip             = "10.10.10.0/24"
            subnet_region         = local.region
            subnet_private_access = "true"
        },
        {
            subnet_name           = "subnet-02"
            subnet_ip             = "10.10.20.0/24"
            subnet_region         = local.region
            subnet_private_access = "true"
        },
        {
            subnet_name               = "subnet-03"
            subnet_ip                 = "10.10.30.0/24"
            subnet_region         = local.region
            subnet_private_access = "true"
        }
    ]

    routes = [
        {
            name                   = "egress-internet"
            description            = "route through IGW to access internet"
            destination_range      = "0.0.0.0/0"
            tags                   = "egress-inet"
            next_hop_internet      = "true"
        },
    ]
    delete_default_internet_gateway_routes = true
}
