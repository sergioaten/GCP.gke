variable "objects_to_upload" {
  default = {}
}

variable "bucket_name" {
  default = "jenkins-project-sasc"
}

variable "project_id" {
  default = "jenkins-project-388812"
}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-a"
}

variable "subnets" {
  type = list(map(string))
  default = [
    {
      subnet_name   = "gke-subnet"
      subnet_ip     = "10.0.0.0/17"
      subnet_region = "us-central1"
    }
  ]
}

variable "gke_node_pools" {
  type = list(map(string))
  default = [
    {
      name            = "node-pool01"
      machine_type    = "n2-highcpu-4"
      node_locations  = "us-central1-a"
      min_count       = 1
      max_count       = 3
      local_ssd_count = 0
      disk_size_gb    = 100
      disk_type       = "pd-standard"
      image_type      = "COS_CONTAINERD"
      auto_repair     = true
      auto_upgrade    = true
      service_account = "1045040505707-compute@developer.gserviceaccount.com"
      preemptible     = true
    }
  ]
}

variable "efk_namespace" {
  default = "efklog"
}
