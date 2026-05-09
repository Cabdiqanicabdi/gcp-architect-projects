output "cluster_name" {
  value       = google_container_cluster.primary.name
  description = "Name of the GKE cluster"
}

output "connect_command" {
  value       = "gcloud container clusters get-credentials ${var.cluster_name} --zone=${var.zone} --project=${var.project_id}"
  description = "Command to connect kubectl to this cluster"
}