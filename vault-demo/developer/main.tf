resource "random_password" "password" {
  length  = 16
  special = false
  numeric = true
}

resource "vault_mount" "db-team" {
  path        = "db"
  type        = "kv-v2"
  description = "This is an example KV Version 2 secret engine mount"
}




resource "vault_generic_secret" "secret" {
  path = "${vault_mount.db-team.path}/db-usernames"
  data_json = jsonencode(
    {
      username = "admin",
      password = "${random_password.password.result}"
    }
  )
}














# resource "google_sql_database_instance" "wordpress" {
#   name                = "wordpress"
#   database_version    = "MYSQL_5_7"
#   region              = "us-central1"
#   deletion_protection = false

#   settings {
#     # Second-generation instance tiers are based on the machine
#     # type. See argument reference below.
#     tier = "db-f1-micro"
#   }
# }


# resource "google_sql_user" "users" {
#   name     = "wordpress"
#   instance = google_sql_database_instance.wordpress.name
#   host     = "wordpress.${var.google_domain_name}"
#   password = random_password.password.result
# }
