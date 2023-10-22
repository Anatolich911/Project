# Create a Kubernetes namespace for ots
module "ots-terraform-k8s-namespace" {
  count  = var.ots ? 1 : 0
  source = "../modules/terraform-k8s-namespace/"
  name   = "ots"
}

