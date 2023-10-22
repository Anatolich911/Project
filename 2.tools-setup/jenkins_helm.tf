module "jenkins-terraform-k8s-namespace" {
  count  = var.jenkins ? 1 : 0
  source = "../modules/terraform-k8s-namespace/"
  name   = "jenkins"
}

module "jenkins-terraform-helm" {
  count                = var.jenkins ? 1 : 0
  source               = "../modules/terraform-helm/"
  deployment_name      = "jenkins"
  deployment_namespace = module.jenkins-terraform-k8s-namespace[0].namespace
  chart                = "jenkins"
  repository           = "https://charts.jenkins.io/"
  chart_version        = var.jenkins-config["chart_version"]
  values_yaml          = <<EOF
controller: 
  installLatestPlugins: true
  ingressClassName: nginx
  ingress:
    enabled: true
    annotations:
      ingress.kubernetes.io/ssl-redirect: "false"
      kubernetes.io/ingress.class: nginx
      cert-manager.io/cluster-issuer: letsencrypt-prod
      acme.cert-manager.io/http01-edit-in-place: "true"
    hosts: 
      - "jenkins.${var.google_domain_name}"
    tls: 
      - secretName: jenkins-server-tls
        hosts:
          - "jenkins.${var.google_domain_name}"
   EOF
}
