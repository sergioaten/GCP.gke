terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.70.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "= 2.11.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "= 2.6.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
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

provider "helm" {
  kubernetes {
    host                   = "https://${module.gke.endpoint}"
    token                  = data.google_client_config.cluster.access_token
    cluster_ca_certificate = base64decode(module.gke.ca_certificate)
  }
}

provider "kubectl" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.cluster.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}
