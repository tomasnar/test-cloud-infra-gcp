locals {
  project_id = var.project_id
  region = var.region
}

module "vpc" {
    source  = "terraform-google-modules/network/google"

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

module "nat" {
  source  = "terraform-google-modules/cloud-nat/google"
  project_id     = local.project_id
  region = local.region
  name = "perkunas-nat"
  network = module.vpc.network_name
  create_router = true
  router = "perkunas-router"
}

resource "google_compute_firewall" "ssh" {
  project = local.project_id
  name    = "allow-ssh"
  network = module.vpc.network_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["35.235.240.0/20"]
}
