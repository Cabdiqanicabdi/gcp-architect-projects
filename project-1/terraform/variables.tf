variable "project_id" {
  description = "Your GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "bucket_name" {
  description = "Bucket name - must be globally unique"
  type        = string
}

variable "website_location" {
  description = "Location for the storage bucket"
  type        = string
  default     = "US"
}
