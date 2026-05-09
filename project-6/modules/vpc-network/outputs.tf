output "network_name" {
  value       = google_compute_network.vpc.name
  description = "Name of the created VPC network"
}

output "network_id" {
  value       = google_compute_network.vpc.id
  description = "ID of the created VPC network"
}

output "subnet_name" {
  value       = google_compute_subnetwork.subnet.name
  description = "Name of the created subnet"
}