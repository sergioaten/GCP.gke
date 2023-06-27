terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.70.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = "us-central1"
  credentials = "credentials.json"
}
