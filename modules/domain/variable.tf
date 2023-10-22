variable "google_domain_name" {
  type        = string
  description = "Please find it in Route53"
}
variable "labels" {
  type = map(string)
  default = {
    quarter = "3"
  }
}