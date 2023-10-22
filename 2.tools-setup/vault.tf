# Create a Kubernetes namespace for Vault
module "vault-terraform-k8s-namespace" {
  count  = var.vault ? 1 : 0
  source = "../modules/terraform-k8s-namespace/"
  name   = "vault"
}

# Deploy Vault using Helm into the Vault namespace
module "vault-terraform-helm" {
  count                = var.vault ? 1 : 0
  source               = "../modules/terraform-helm/"
  deployment_name      = "vault" #var.vault-config["deployment_name"]
  deployment_namespace = module.vault-terraform-k8s-namespace[0].namespace
  chart                = "vault"
  chart_version        = var.vault-config["chart_version"]
  repository           = "https://helm.releases.hashicorp.com"
  values_yaml          = <<EOF
# Add Vault configuration settings here

global:
  # enabled is the master enabled switch. Setting this to true or false
  # will enable or disable all the components within this chart by default.
  enabled: true
  
server:  
  resources:
    requests:
      memory: 256Mi
      cpu: 250m
    limits:
      memory: 512Mi
      cpu: 500m


  annotations: {
    "cluster-autoscaler.kubernetes.io/safe-to-evict": "true"
  }
  ingress:
    enabled: true
    annotations: 
      nginx.ingress.kubernetes.io/proxy-body-size: "0"
      ingress.kubernetes.io/ssl-redirect: "false"
      cert-manager.io/cluster-issuer: letsencrypt-prod
      acme.cert-manager.io/http01-edit-in-place: "true"
    ingressClassName: "nginx"
    hosts:
    - host: "vault.${var.google_domain_name}"
      http:
        paths:
        - pathType: Prefix
          path: "/"
          backend:
            service:
              name: vault
              port:
                number: 8200

    tls: 
      - secretName: vault-tls
        hosts:
          - "vault.${var.google_domain_name}"
EOF
}
