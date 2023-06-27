variable "objects_to_upload" {
  default = {}
  }

  variable "bucket_name" {
    default = "jenkins-project-sasc"    
  }

  variable "project_id" {
    default = "jenkins-project-388812"    
  }

  variable "subnets" {
  type    = list(map(string))
  default = [
    {
      subnet_name   = "gke-subnet"
      subnet_ip     = "10.0.0.0/20"
      subnet_region = "us-central1"
    }
  ]
}