locals {
  project_id = var.project_id
  region = var.region
}

module "vpc" {
  source = "../vpc"
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
  tags                = ["k8s"]
  service_account      = {
                           email = module.service_account.email
                           scopes = ["cloud-platform"]
                         }
}

module "control_vm" {
  source            = "terraform-google-modules/vm/google//modules/compute_instance"
  hostname          = "perkunas-control"
  add_hostname_suffix = false
  instance_template = module.instance_template.self_link
}

module "worker_vm1" {
  source            = "terraform-google-modules/vm/google//modules/compute_instance"
  hostname          = "perkunas-worker"
  num_instances     = 2
  instance_template = module.instance_template.self_link
}

module "service_account" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0"
  project_id    = local.project_id
  prefix        = "sa-k8-vm"
  names         = ["cluster"]
  project_roles = []
  display_name  = "vm k8 sa"
  description   = "VM Service account"
}
