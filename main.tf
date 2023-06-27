locals {
  subnet_name = var.subnets[0]["subnet_name"]
  secondary_ranges = {
    (local.subnet_name) = [
      {
        range_name    = "pod"
        ip_cidr_range = "192.168.0.0/24"
      },
      {
        range_name    = "svc"
        ip_cidr_range = "192.168.1.0/24"
      }
    ]
  }
}

resource "google_storage_bucket_object" "uploaded_objects" {
  for_each = {
    for obj_name, obj in var.objects_to_upload : obj_name => obj
  }

  name   = each.value.remote_path
  bucket = var.bucket_name
  source = each.value.local_path
}

module "network" {
  source  = "terraform-google-modules/network/google"
  version = "7.0.0"
  # insert the 3 required variables here
  project_id       = var.project_id
  network_name     = "example-network"
  subnets          = var.subnets
  secondary_ranges = local.secondary_ranges
}

data "google_client_config" "cluster" {
  provider = google
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "26.1.1"
  # insert the 6 required variables here
  project_id = var.project_id
  regional   = false
  region     = var.region
  zones      = [var.zone]

  name = "gke-cluster"

  network           = module.network.network_name
  subnetwork        = module.network.subnets_names[0]
  ip_range_pods     = module.network.subnets_secondary_ranges[0].ip_cidr_range
  ip_range_services = module.network.subnets_secondary_ranges[1].ip_cidr_range
  node_pools        = var.gke_node_pools
}
