locals {
  subnet_name = var.subnets[0]["subnet_name"]
  secondary_ranges = {
    (local.subnet_name) = [
      {
        range_name    = "ip-range-pods"
        ip_cidr_range = "192.168.0.0/18"
      },
      {
        range_name    = "ip-range-svc"
        ip_cidr_range = "192.168.64.0/18"
      }
    ]
  }
  secondary_ranges_obj = module.network.subnets_secondary_ranges[0]
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
  ip_range_pods     = local.secondary_ranges_obj[0].range_name
  ip_range_services = local.secondary_ranges_obj[1].range_name
  node_pools        = var.gke_node_pools
}

resource "kubernetes_namespace" "efk" {
  metadata {
    name = var.efk_namespace
  }
}
