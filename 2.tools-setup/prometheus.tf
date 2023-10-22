# Create a Kubernetes namespace for Prometheus
module "prometheus-terraform-k8s-namespace" {
  count  = var.prometheus ? 1 : 0
  source = "../modules/terraform-k8s-namespace/"
  name   = "prometheus"
}

# Deploy Prometheus using Helm into the Prometheus namespace
module "prometheus-terraform-helm" {
  count                = var.prometheus ? 1 : 0
  source               = "../modules/terraform-helm/"
  deployment_name      = "prometheus"
  deployment_namespace = module.prometheus-terraform-k8s-namespace[0].namespace
  chart                = "prometheus"
  repository           = "https://prometheus-community.github.io/helm-charts"
  chart_version        = var.prometheus-config["chart_version"]
  values_yaml          = <<-EOF
server:
  ingress:
    enabled: true
    annotations: 
      ingress.kubernetes.io/ssl-redirect: "false"
      kubernetes.io/ingress.class: nginx
      cert-manager.io/cluster-issuer: letsencrypt-prod-dns01
      acme.cert-manager.io/http01-edit-in-place: "true"
    hosts: 
      - "prometheus.${var.google_domain_name}"
    path: /
    pathType: Prefix
    tls: 
      - secretName: prometheus-server-tls
        hosts:
          - "prometheus.${var.google_domain_name}"
alertmanager:
  enabled: true
  EOF
}
