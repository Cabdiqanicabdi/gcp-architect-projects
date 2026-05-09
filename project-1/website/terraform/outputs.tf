output "load_balancer_ip" {
description = "The IP address of your Load Balancer — point your domain DNS here"
value = google_compute_global_address.website.address
}
 
output "bucket_name" {
description = "Your Cloud Storage bucket name"
value = google_storage_bucket.website.name
}
 
output "website_url" {
  description = "Direct bucket URL"
  value       = "https://storage.googleapis.com/abdikani-website-2024/index.html"
}