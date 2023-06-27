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
      subnet_ip     = "10.0.0.0/20"
      subnet_region = "us-central1"
    },
    {
      subnet_name   = "gke-subnet2"
      subnet_ip     = "10.1.0.0/20"
      subnet_region = "us-central1"
    }
  ]
}

variable "subnets_secondary_ranges" {
  type = list(map(string))
  default = [
    {
      range_name    = "us-central1-01-gke-01-pods"
      ip_cidr_range = "192.168.64.0/24"
    },
    {
      range_name    = "us-central1-01-gke-01-services"
      ip_cidr_range = "192.168.64.0/24"
    }
  ]
}

variable "gke_node_pools" {
  type = list(map(string))
  default = [
    {
      name            = "node-pool01"
      machine_type    = "e2-medium"
      node_locations  = "us-central1-a"
      min_count       = 1
      max_count       = 2
      local_ssd_count = 0
      spot            = false
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
