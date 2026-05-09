resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.zone
  project  = var.project_id

  deletion_protection = false
  initial_node_count  = var.node_count

  network    = var.network_name
  subnetwork = var.subnet_name

  node_config {
      labels = {
      managed-by = "terraform"
      owner      = "abdikani"
    }
    machine_type = var.machine_type
    disk_size_gb = 20
    disk_type    = "pd-standard"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}