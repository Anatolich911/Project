output "address" {
  value = aws_db_instance.default.address
}

output "config" {
  value = [
    google_sql_database_instance.main.name,
    google_sql_database_instance.main.connection_name,
    google_sql_database_instance.main.first_ip_address,
    google_sql_database_instance.main.public_ip_address,
    google_sql_database_instance.main.self_link
  ]
}
