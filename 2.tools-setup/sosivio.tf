module "sosivio-terraform-k8s-namespace" {
  count  = var.sosivio ? 1 : 0
  source = "../modules/terraform-k8s-namespace/"
  name   = "sosivio"
}

module "sosivio-terraform-helm" {
  count                = var.sosivio ? 1 : 0
  source               = "../modules/terraform-helm/"
  deployment_name      = "sosivio"
  deployment_namespace = module.sosivio-terraform-k8s-namespace[0].namespace
  chart                = "sosivio"
  repository           = "https://helm.sosiv.io"
  values_yaml          = <<EOF
 platform: gke 
 cluster_name: ${var.gke_config["cluster_name"]} 
 EOF
}
