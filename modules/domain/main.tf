resource "google_dns_managed_zone" "project" {
  name     = "hosted-zone"
  dns_name = "${var.google_domain_name}."
  labels   = var.labels
}