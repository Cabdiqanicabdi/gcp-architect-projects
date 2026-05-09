terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}
provider "google" {
  project = var.project_id
  region  = var.region
}
resource "google_compute_address" "nginx_vm" {
  name   = "abdikani-nginx-ip"
  region = var.region
}
resource "google_compute_firewall" "allow_ssh" {
  name    = "abdikani-allow-ssh"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = [var.your_ip]
  target_tags   = ["nginx-server"]
}
resource "google_compute_firewall" "allow_http" {
  name    = "abdikani-allow-http"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["nginx-server"]
}
resource "google_compute_instance" "nginx_vm" {
  name         = "abdikani-nginx-server"
  machine_type = "e2-micro"
  zone         = var.zone
  tags         = ["nginx-server"]
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
    }
  }
  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.nginx_vm.address
    }
  }
  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install nginx -y
    systemctl enable nginx
    systemctl start nginx
    echo '<html><body style="background:#0d1117;color:#58a6ff;font-family:sans-serif;text-align:center;padding:60px"><h1>Hello from Abdikani VM</h1><p>Running on GCP Compute Engine with Nginx</p></body></html>' > /var/www/html/index.html
  EOF
}