output "instance_name" {
    value = google_sql_database_instance.main.name
    description = "Cloud SQL instance name"
    }

output "public_ip" {
    value = google_sql_database_instance.main.public_ip_address
    description = "public IP address of the database"
    }

output "connection_name" {
    value = google_sql_database_instance.main.connection_name
    description = "Connection name for Cloud SQL proxy"
    }