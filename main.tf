locals {
  project_id = "tomasnar-test-terraform"
  region = "asia-southeast1"
}

module "mig" {
  source = "./modules/mig"
  project_id = local.project_id
  region = local.region
}
