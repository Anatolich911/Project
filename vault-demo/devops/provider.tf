provider "vault" {
  address = "https://vault.${var.google_domain_name}"
  token   = var.vault_token
}
