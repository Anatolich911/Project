# This block sets a google_domain_name
variable "google_domain_name" {
  description = "Please provide a google_domain_name"
  type        = string
  default     = ""
}

# This block sets a vault token
variable "vault_token" {
  description = "Please provide a vault token"
  type        = string
  default     = ""
}
