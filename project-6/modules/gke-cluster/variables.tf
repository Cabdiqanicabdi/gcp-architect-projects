variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "zone" {
  type        = string
  description = "GCP zone for the cluster"
  default     = "us-central1-a"
}

variable "cluster_name" {
  type        = string
  description = "Name of the GKE cluster"
}

variable "node_count" {
  type        = number
  description = "Number of nodes in the cluster"
  default     = 1
}

variable "machine_type" {
  type        = string
  description = "Machine type for nodes"
  default     = "e2-small"
}

variable "network_name" {
  type        = string
  description = "VPC network name from vpc-network module"
}

variable "subnet_name" {
  type        = string
  description = "Subnet name from vpc-network module"
}