# Set region info
variable "region" {
  description = "Please provide a region"
  default     = "us-east-1"
  type        = string
}

# Set project name
variable "project_name" {
  description = "Please provide a project_name"
  default     = "aws-to-gcp"
  type        = string
}

# Set domain info
variable "google_domain_name" {
  description = "Please provide a domain name"
  default     = ""
  type        = string
}

variable "project_id" {}
