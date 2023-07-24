locals {
  project_id = "tomasnar-test-terraform"
  region = "us-east1"
}

# module "mig" {
#   source = "./modules/mig"
#   project_id = local.project_id
#   region = local.region
# }

module "k8s" {
  source = "./modules/k8_cluster"
  project_id = local.project_id
  region = local.region
 }