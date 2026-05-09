terraform {
required_providers {
google = { source = "hashicorp/google", version = "~> 5.0" }
}
}
provider "google" {
project = var.project_id
region = var.region
}
resource "google_compute_global_address" "private_ip_range" {
name = "abdikani-db-private-range"
purpose = "VPC_PEERING"
address_type = "INTERNAL"
prefix_length = 16
network = "default"
}
resource "google_service_networking_connection" "private_vpc" {
network = "projects/${var.project_id}/global/networks/default"
service = "servicenetworking.googleapis.com"
reserved_peering_ranges = [google_compute_global_address.private_ip_range.name]
}

resource "google_sql_database_instance" "main" {
name = "abdikani-db"
database_version = "POSTGRES_15"
region = var.region
deletion_protection = false

settings {
tier = "db-f1-micro"
ip_configuration {
ipv4_enabled = false
private_network = "projects/${var.project_id}/global/networks/default"
}
backup_configuration {
enabled = true
start_time = "02:00"
}
}
depends_on = [google_service_networking_connection.private_vpc]
}
resource "google_sql_database" "appdb" {
name = "appdb"
instance = google_sql_database_instance.main.name
}

resource "google_sql_user" "appuser" {
name = "appuser"
instance = google_sql_database_instance.main.name
password = var.db_password
}