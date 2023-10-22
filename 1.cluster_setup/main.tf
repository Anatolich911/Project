module "gke" {
  source      = "../modules/gke/"
  preemptible = true
  gke_config = {
    location       = "us-central1-a" # this can be region or zone
    cluster_name   = "project-cluster"
    machine_type   = "e2-highmem-2"
    node_count     = 1
    node_pool_name = "my-node-pool"
    disk_size_gb   = 30
    node_version   = "1.27.3-gke.100" # finds build version automatically based on region. We can change it to 1.21   . In this case it will automatically find minor version
  }
}
