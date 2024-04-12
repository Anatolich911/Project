module "artemis-terraform-k8s-namespace" {
  source = "../modules/terraform-k8s-namespace/"
  name   = "artemis"
}

module "artemis-terraform-helm" {
  source               = "../modules/terraform-helm-local/"
  deployment_name      = "artemis-dev"
  deployment_namespace = module.artemis-terraform-k8s-namespace.namespace
  deployment_path      = "charts/application"
  values_yaml          = <<EOF

replicaCount: 1

image:
  repository: "${var.artemis-config["repository"]}"
  pullPolicy: IfNotPresent
  # Overrides the image tag whose default is the chart appVersion.
  tag: "${var.artemis-config["tag"]}"

###################################################### 
#
#
#       This line enables artemis for public 
#
#
######################################################

service:
  type: ClusterIP
  port: 5000


ingress:
  enabled: true
  className: "nginx"
  annotations: 
    ingress.kubernetes.io/ssl-redirect: "false"
    cert-manager.io/cluster-issuer: letsencrypt-prod-dns01
    acme.cert-manager.io/http01-edit-in-place: "true"
  hosts:
    - host: artemis-dev.${var.google_domain_name}
      paths:
        - path: /
          pathType: ImplementationSpecific
  tls: 
    - secretName: chart-example-tls
      hosts:
        - artemis-dev.${var.google_domain_name}
EOF
}
