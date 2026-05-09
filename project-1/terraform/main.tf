terraform {
required_providers {
google = {
source = "hashicorp/google"
version = "~> 5.0"
}
}
}
 
provider "google" {
project = var.project_id
region = var.region
}
 
resource "google_storage_bucket" "website" {
name = var.bucket_name
location = var.website_location
force_destroy = true
 

website {
main_page_suffix = "index.html"
not_found_page = "404.html"
}
 

uniform_bucket_level_access = true
}
resource "google_storage_bucket_iam_member" "public_read" {
bucket = google_storage_bucket.website.name
role = "roles/storage.objectViewer"
member = "allUsers"
}
resource "google_compute_backend_bucket" "website_backend" {
name = "abdikani-website-backend"
bucket_name = google_storage_bucket.website.name
enable_cdn = true
 
cdn_policy {
cache_mode = "CACHE_ALL_STATIC"
client_ttl = 3600
default_ttl = 3600
max_ttl = 86400
negative_caching = true
}
}
 
resource "google_compute_url_map" "website" {
name = "abdikani-website-urlmap"
default_service = google_compute_backend_bucket.website_backend.id
}

resource "google_compute_managed_ssl_certificate" "website" {
name = "abdikani-ssl-cert"
managed {
domains = ["abdikani-cloud.com"]
}
}

resource "google_compute_target_https_proxy" "website" {
name = "abdikani-https-proxy"
url_map = google_compute_url_map.website.id
ssl_certificates = [google_compute_managed_ssl_certificate.website.id]
}

resource "google_compute_global_address" "website" {
name = "abdikani-website-ip"
}
resource "google_compute_url_map" "http_redirect" {
name = "abdikani-http-redirect"
default_url_redirect {
https_redirect = true
strip_query = false
}
}
 
resource "google_compute_target_http_proxy" "http_redirect" {
name = "abdikani-http-proxy"
url_map = google_compute_url_map.http_redirect.id
}
 
resource "google_compute_global_forwarding_rule" "http_redirect" {
name = "abdikani-website-http"
target = google_compute_target_http_proxy.http_redirect.id
port_range = "80"
ip_address = google_compute_global_address.website.address
}
