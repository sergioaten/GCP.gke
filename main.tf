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
  project_id = var.project_id
  network_name = "example-network"
  subnets = var.subnets
}

module "kubernetes-engine" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "26.1.1"
  # insert the 6 required variables here
  project_id = var.project_id
  name = "gke-cluster"
  zones = ["us-central1-a"]
  network = module.network.network_name
  ip_range_pods = "us-central1-01-gke-01-pods"
  ip_range_services = "us-central1-01-gke-01-services"
  subnetwork = "10.0.0.0/20"
}