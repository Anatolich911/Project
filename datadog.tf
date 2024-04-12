module "datadog-terraform-k8s-namespace" {
  count  = var.datadog ? 1 : 0
  source = "../modules/terraform-k8s-namespace/"
  name   = "datadog"
}

module "datadog-terraform-helm" {
  count                = var.datadog ? 1 : 0
  source               = "../modules/terraform-helm-local/"
  deployment_name      = var.datadog-config["deployment_name"]
  deployment_namespace = module.datadog-terraform-k8s-namespace[0].namespace
  deployment_path      = "charts/datadog"
  values_yaml          = <<EOF
datadog:
  clusterName: "${var.gke_config["cluster_name"]}"
  site: "${var.datadog-config["site"]}"
  apiKey: "${var.datadog-config["apiKey"]}"
  logs:
    enabled: true 
    containerCollectAll: true
# clusterAgent:
#   resources: 
#     requests:
#       cpu: "${var.datadog-config["cpu_requests"]}"
#       memory: "${var.datadog-config["memory_requests"]}"
#     limits:
#       cpu: "${var.datadog-config["cpu_limits"]}"
#       memory: "${var.datadog-config["memory_limits"]}"
EOF
}
