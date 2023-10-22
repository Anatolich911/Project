provider "aws" {
  region = var.region
}
provider "google" {
  project = var.project_id
}
