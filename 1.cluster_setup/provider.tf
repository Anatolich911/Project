# Provider Configuration
# The body of the block contains configuration arguments for google

provider "google" {
  zone = "us-central1-a" # this can be region or zone
}
provider "google-beta" {
  zone = "us-central1-a" # this can be region or zone
}
