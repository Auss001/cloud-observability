output "db_private_ip" {
  value = google_sql_database_instance.postgres.private_ip_address
}

output "db_name" {
  value = google_sql_database.database.name
}