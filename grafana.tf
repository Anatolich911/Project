# Create a Kubernetes namespace for Grafana
module "grafana-terraform-k8s-namespace" {
  count  = var.grafana ? 1 : 0
  source = "../modules/terraform-k8s-namespace/"
  name   = "grafana"
}

# Deploy Grafana using Helm into the Grafana namespace
module "grafana-terraform-helm" {
  count                = var.grafana ? 1 : 0
  source               = "../modules/terraform-helm/"
  deployment_name      = "grafana"
  deployment_namespace = module.grafana-terraform-k8s-namespace[0].namespace
  chart                = "grafana"
  chart_version        = var.grafana-config["chart_version"]
  repository           = "https://grafana.github.io/helm-charts"
  values_yaml          = <<EOF

# Add Grafana configuration settings here

dashboardProviders: 
 dashboardproviders.yaml:
   apiVersion: 1
   providers:
   - name: 'default'
     orgId: 1
     folder: ''
     type: file
     disableDeletion: false
     editable: true
     options:
       path: /var/lib/grafana/dashboards/default
dashboards: 
  default:
    kubernetes-apiserver:
      file: dashboards/kubernetes-apiserver.json
    kubernetes-monitoring:
      file: dashboards/kubernetes-monitoring.json     
    kubernetes-nodes:
      file: dashboards/kubernetes-nodes.json
    kubernetes-volume:
      file: dashboards/kubernetes-volume.json
    kubernetes-pod-overview:
      file: dashboards/kubernetes-pod-overview.json
    kubernetes-views-global: 
      file: dashboards/kubernetes-views-global.json
    k8s:
      file: dashboards/k8s.json
ingress:
  enabled: true
  annotations:
    ingress.kubernetes.io/ssl-redirect: "false"
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: letsencrypt-prod-dns01
    acme.cert-manager.io/http01-edit-in-place: "true"
  path: /
  hosts:
    - "grafana.${var.google_domain_name}"
  tls:
    - secretName: grafana-tls
      hosts:
        - "grafana.${var.google_domain_name}"
resources: 
  requests:
    cpu: 50m
    memory: 50Mi
  limits:
    cpu: 500m
    memory: 512Mi
persistence:
  type: pvc
  enabled: true
adminUser: "${var.grafana-config["adminUser"]}"
adminPassword: "${var.grafana-config["adminPassword"]}"
datasources:
 datasources.yaml:
   apiVersion: 1
   datasources:
   - name: Prometheus
     type: prometheus
     url: http://prometheus-server.prometheus.svc.cluster.local:80
     access: proxy
     isDefault: true

---
apiVersion: v1
kind: ConfigMap
metadata:
  name: grafana-dashboards
data:
  kubernetes-apiserver:
    file: dashboards/kubernetes-apiserver.json
  kubernetes-monitoring:
    file: dashboards/kubernetes-monitoring.json
  kubernetes-nodes:
    file: dashboards/kubernetes-nodes.json
  kubernetes-volume:
    file: dashboards/kubernetes-volume.json
  kubernetes-pod-overview:
    file: dashboards/kubernetes-pod-overview.json
  kubernetes-views-global:
    file: dashboards/kubernetes-views-global.json
  k8s:
    file: dashboards/k8s.json
EOF
}
