variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "network_name" {
  type        = string
  description = "Name of the VPC network"
  default     = "abdikani-vpc"
}

variable "region" {
  type        = string
  description = "GCP region"
  default     = "us-central1"
}