# Enables all services needed for a project
resource "null_resource" "enable-api" {
  # Execute always
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<-EOT
        gcloud services enable compute.googleapis.com
        gcloud services enable dns.googleapis.com
        gcloud services enable storage-api.googleapis.com
        gcloud services enable container.googleapis.com
        gcloud services enable file.googleapis.com
        gcloud services enable artifactregistry.googleapis.com
        gcloud services enable cloudresourcemanager.googleapis.com
        gcloud services enable containeranalysis.googleapis.com
        gcloud services enable tenor.googleapis.com
    EOT
  }
}

# Creates a cluster
resource "google_container_cluster" "primary" {
  # Explicit dependency on API services
  depends_on = [
    null_resource.enable-api,
  ]
  name                     = var.gke_config["cluster_name"]
  location                 = var.gke_config["location"]
  remove_default_node_pool = true
  initial_node_count       = var.gke_config["node_count"]
  # node_version             = var.gke_config["node_version"]
  min_master_version = var.gke_config["node_version"]
  lifecycle {
    ignore_changes = ["node_version"]
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name           = var.gke_config["node_pool_name"]
  cluster        = google_container_cluster.primary.name
  node_count     = var.gke_config["node_count"]
  version        = var.gke_config["node_version"]
  node_locations = [var.gke_config["location"]]
  node_config {
    preemptible  = var.preemptible
    machine_type = var.gke_config["machine_type"]
    disk_size_gb = var.gke_config["disk_size_gb"]
  }
  autoscaling {
    location_policy      = "ANY"
    max_node_count       = 1000
    min_node_count       = 1
    total_max_node_count = 0
    total_min_node_count = 0
  }
  lifecycle {
    ignore_changes = ["version"]
  }
  management {
    auto_repair  = true
    auto_upgrade = true
  }
}




# Get credentials
resource "null_resource" "set-kubeconfig" {
  depends_on = [
    google_container_cluster.primary,
  ]
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.gke_config["cluster_name"]} --zone ${var.gke_config["location"]} --project $GOOGLE_PROJECT"
  }
}
