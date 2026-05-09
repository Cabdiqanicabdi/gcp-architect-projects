output "vm_external_ip" {
  value = google_compute_address.nginx_vm.address
}
output "ssh_command" {
  value = "gcloud compute ssh abdikani-nginx-server --zone=us-central1-a"
}