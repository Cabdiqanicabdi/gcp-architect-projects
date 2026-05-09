output "db_private_ip" {
value = google_sql_database_instance.main.private_ip_address
description = "Private IP of Cloud SQL — use this in your app config"
}
output "db_connection_name" {
value = google_sql_database_instance.main.connection_name
}
