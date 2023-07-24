locals {
  project_id = var.project_id
  region = var.region
}

module "vpc" {
  source = "./vpc"
  project_id = var.project_id
  region = var.region
}

module "instance_template" {
  source               = "terraform-google-modules/vm/google//modules/instance_template"
  project_id           = local.project_id
  subnetwork           = module.vpc.subnets_names[0]
  machine_type         = "e2-micro"
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
  project_roles = []
  display_name  = "vm sa"
  description   = "VM Service account"
}
