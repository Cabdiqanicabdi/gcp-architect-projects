terraform {
required_providers {
google = { source = "hashicorp/google", version = "~> 5.0" }
}
}
provider "google" {
project = var.project_id
region = var.region
}
resource "google_pubsub_topic" "orders" {
name = "abdikani-orders"
message_retention_duration = "86400s" # keep messages 24 hours
}
resource "google_pubsub_topic" "orders_dead_letter" {
name = "abdikani-orders-dead-letter"
}
resource "google_pubsub_subscription" "orders_sub" {
name = "abdikani-orders-sub"
topic = google_pubsub_topic.orders.name
ack_deadline_seconds = 60
retry_policy {
minimum_backoff = "10s"
maximum_backoff = "300s"
}
dead_letter_policy {
dead_letter_topic = google_pubsub_topic.orders_dead_letter.id
max_delivery_attempts = 5
}
}
resource "google_storage_bucket" "functions" {
name = "${var.project_id}-functions"
location = var.region
force_destroy = true
uniform_bucket_level_access = true
}
data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = "../function"
  output_path = "/tmp/function.zip"
}
resource "google_storage_bucket_object" "function_zip" {
name = "function-${data.archive_file.function_zip.output_md5}.zip"
bucket = google_storage_bucket.functions.name
source = data.archive_file.function_zip.output_path
}
resource "google_cloudfunctions2_function" "process_order" {
name = "abdikani-process-order"
location = var.region
build_config {
runtime = "python311"
entry_point = "process_order"
source {
storage_source {
bucket = google_storage_bucket.functions.name
object = google_storage_bucket_object.function_zip.name
}
}
}
service_config {
min_instance_count = 0
max_instance_count = 10
timeout_seconds = 60
available_memory = "256M"
}
event_trigger {
    trigger_region = var.region
event_type = "google.cloud.pubsub.topic.v1.messagePublished"
pubsub_topic = google_pubsub_topic.orders.id
retry_policy = "RETRY_POLICY_RETRY"
}
}
resource "google_cloud_run_service_iam_member" "invoker" {
  location = var.region
  service  = google_cloudfunctions2_function.process_order.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

data "google_project" "project" {}


