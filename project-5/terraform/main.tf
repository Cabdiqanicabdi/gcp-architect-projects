terraform {
required_providers {
google = { source = "hashicorp/google", version = "~> 5.0" }
}
}
provider "google" {
project = var.project_id
region = var.region
}
resource "google_container_cluster" "primary" {
name = var.cluster_name
location = var.zone
deletion_protection = false
remove_default_node_pool = true
initial_node_count = 1
workload_identity_config {
workload_pool = "${var.project_id}.svc.id.goog"
}
}
resource "google_container_node_pool" "primary_nodes" {
name = "abdikani-node-pool"
location = var.zone
cluster = google_container_cluster.primary.name
node_count = 2
node_config {
machine_type = "e2-medium"
disk_size_gb = 30
oauth_scopes = [
"https://www.googleapis.com/auth/cloud-platform"
]
}
management {
auto_repair = true
auto_upgrade = true
}
}