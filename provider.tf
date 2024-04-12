provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  # experiments {
  #   manifest = true
  # }
  kubernetes {
    config_path = "~/.kube/config"
  }
}
