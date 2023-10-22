# module "sumologic-terraform-k8s-namespace" {
#   source = "../modules/terraform-k8s-namespace/"
#   name   = "sumologic"
# }

# module "sumologic-terraform-helm" {
#   count                = var.sumologic ? 1 : 0
#   source               = "../modules/terraform-helm/"
#   deployment_name      = var.sumologic-config["deployment_name"]
#   deployment_namespace = module.sumologic-terraform-k8s-namespace.namespace
#   chart                = "sumologic"
#   repository           = "https://sumologic.github.io/sumologic-kubernetes-collection"
#   chart_version        = var.sumologic-config["chart_version"]
#   values_yaml          = <<-EOF
# sumologic:
#   accessId: "sujsh05bGLoWby"
#   accessKey: "S4rDAZPbjyLfBmfK8CVbLoQZHcTeiECY8yu76PZOqRL8Osu1lKxmTaKPDB7P6Zr5"
#   clusterName: "${var.gke_config["cluster_name"]}"

#   EOF
# }
