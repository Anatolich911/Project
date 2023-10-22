# This block is used to setup coder
variable "coder-config" {
  type = map(any)
  default = {
    deployment_name = "coder"
    chart_version   = "6.43.3"
    adminPassword   = "password"
    adminUser       = "admin"
  }
}
variable "google_domain_name" {}
