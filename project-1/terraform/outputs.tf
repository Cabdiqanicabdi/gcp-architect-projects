output "load_balancer_ip" {
  description = "Load Balancer IP - point your DNS here"
  value       = google_compute_global_address.website.address
}

output "bucket_name" {
  description = "Your bucket name"
  value       = google_storage_bucket.website.name
}
