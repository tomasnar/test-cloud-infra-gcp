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

provider "google-beta" {
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
    ]

    # routes = [
    #     {
    #         name                   = "egress-internet"
    #         description            = "route through IGW to access internet"
    #         destination_range      = "0.0.0.0/0"
    #         tags                   = "egress-inet"
    #         next_hop_internet      = "true"
    #     },
    # ]
    delete_default_internet_gateway_routes = true
}

# module "nat" {
#   source  = "terraform-google-modules/cloud-nat/google//examples/nat_with_compute_engine"
#   version = "4.1.0"
#   project     = local.project_id
#   region      = local.region
#   subnet      = 
# }

resource "google_compute_firewall" "ssh" {
  project = local.project_id
  name    = "allow-ssh"
  network = module.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["58.182.175.57/32"]
}

module "instance_template" {
  source               = "terraform-google-modules/vm/google//modules/instance_template"
  project_id           = local.project_id
  subnetwork              = module.vpc.subnets_names[0]
  source_image_project = "ubuntu-os-cloud"
  source_image_family  = "ubuntu-2204-lts"
  disk_size_gb         = 20
  service_account      = {
                           email = module.service_account.email
                           scopes = ["cloud-platform"]
                         }
}

module "mig" {
  source            = "terraform-google-modules/vm/google//modules/mig"
  project_id        = local.project_id
  region            = local.region
  target_size       = 3
  hostname          = "perkunas-cluster"
  instance_template = module.instance_template.self_link
}

module "service_account" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0"
  project_id    = local.project_id
  prefix        = "sa-vm"
  names         = ["cluster"]
  project_roles = ["roles/iap.tunnelResourceAccessor"]
  display_name  = "vm sa"
  description   = "VM Service account"
}
