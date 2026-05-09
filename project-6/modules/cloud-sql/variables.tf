variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "GCP region"
  default     = "us-central1"
}

variable "db_instance_name" {
  type        = string
  description = "Name of the Cloud SQL instance"
}

variable "db_name" {
  type        = string
  description = "Name of the database"
  default     = "appdb"
}

variable "db_user" {
  type        = string
  description = "Database user name"
  default     = "appuser"
}

variable "db_password" {
  type        = string
  description = "Database password"
  sensitive   = true
}

variable "db_tier" {
  type        = string
  description = "Machine type for database"
  default     = "db-f1-micro"
}

variable "availability_type" {
  type        = string
  description = "ZONAL for dev, REGIONAL for prod"
  default     = "ZONAL"
}