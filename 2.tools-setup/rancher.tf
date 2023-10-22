# ╷
# │ 

# ╷
# │ 



# |   Error: chart requires kubeVersion: < 1.27.0-0 which is incompatible with Kubernetes v1.27.3-gke.100
# │ 
# │   with module.rancher-terraform-helm.helm_release.helm_deployment,
# │   on ../modules/terraform-helm/main.tf line 1, in resource "helm_release" "helm_deployment":
# │    1: resource "helm_release" "helm_deployment" {
# │ 
# ╷
# │ 
# ╷
# │ 
# ╷
# │ 





# module "rancher-terraform-k8s-namespace" {
#   source = "../modules/terraform-k8s-namespace/"
#   name   = "rancher"
# }

# module "rancher-terraform-helm" {
#   source               = "../modules/terraform-helm/"
#   deployment_name      = "rancher"
#   deployment_namespace = module.rancher-terraform-k8s-namespace.namespace
#   chart                = "rancher"
#   repository           = "https://releases.rancher.com/server-charts/latest"
#   chart_version        = "2.7.7-rc4"
#   values_yaml          = <<-EOF

#   EOF
# }
