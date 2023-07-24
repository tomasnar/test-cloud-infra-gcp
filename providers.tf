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