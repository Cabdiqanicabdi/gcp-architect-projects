output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "connect_command" {
  value = "gcloud container clusters get-credentials abdikani-cluster --zone=us-central1-a --project=total-pillar-495011-r7"
}