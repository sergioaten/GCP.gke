terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.70.0"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = "us-central1"
  credentials = file("/home/sergio/github/.credentials/terraform.json")
}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.cluster.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}
