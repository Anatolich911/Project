# Create uptime check monitoring for vault 
module "vault" {
  count              = var.vault ? 1 : 0
  source             = "../modules/monitoring"
  google_domain_name = var.google_domain_name
  project_id         = var.project_id
  service_name       = "vault"
}

# Create uptime check monitoring for grafana
module "grafana" {
  count              = var.grafana ? 1 : 0
  source             = "../modules/monitoring"
  google_domain_name = var.google_domain_name
  project_id         = var.project_id
  service_name       = "grafana"
}

# Create uptime check monitoring for prometheus
module "prometheus" {
  count              = var.prometheus ? 1 : 0
  source             = "../modules/monitoring"
  google_domain_name = var.google_domain_name
  project_id         = var.project_id
  service_name       = "prometheus"
}

# Create uptime check monitoring for alertmanager
module "alertmanager" {
  source             = "../modules/monitoring"
  google_domain_name = var.google_domain_name
  project_id         = var.project_id
  service_name       = "alertmanager"
}

# Create uptime check monitoring for argocd
module "argocd" {
  count              = var.argo ? 1 : 0
  source             = "../modules/monitoring"
  google_domain_name = var.google_domain_name
  project_id         = var.project_id
  service_name       = "argocd"
}

# Create uptime check monitoring for jenkins
module "jenkins" {
  count              = var.jenkins ? 1 : 0
  source             = "../modules/monitoring"
  google_domain_name = var.google_domain_name
  project_id         = var.project_id
  service_name       = "jenkins"
}

# Create uptime check monitoring for sftpgo
module "sftpgo" {
  source             = "../modules/monitoring"
  google_domain_name = var.google_domain_name
  project_id         = var.project_id
  service_name       = "sftpgo"
}
