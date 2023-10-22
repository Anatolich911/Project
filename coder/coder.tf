module "coder-terraform-k8s-namespace" {
  source = "../modules/terraform-k8s-namespace/"
  name   = "coder"
}

module "postgresql-terraform-helm" {
  depends_on = [
    kubernetes_secret.example
  ]
  source               = "../modules/terraform-helm/"
  deployment_name      = "postgresql"
  deployment_namespace = module.coder-terraform-k8s-namespace.namespace
  chart                = "postgresql"
  chart_version        = "12.1.3"
  repository           = "https://charts.bitnami.com/bitnami"
  values_yaml          = <<EOF
auth:
  username: coder
  password: coder
  database: coder
persistence:
  size: 10Gi
EOF
}

resource "kubernetes_secret" "example" {
  metadata {
    name      = "coder-db-url"
    namespace = "coder"
  }

  data = {
    coder-db-url = "postgres://coder:coder@postgresql.coder.svc.cluster.local:5432/coder?sslmode=disable"
  }

  type = "generic"
}





module "coder-terraform-helm" {
  source               = "../modules/terraform-helm/"
  deployment_name      = "coder" #var.coder-config["deployment_name"]
  deployment_namespace = module.coder-terraform-k8s-namespace.namespace
  chart                = "coder"
  chart_version        = "1.37.1"
  repository           = "https://helm.coder.com"
  values_yaml          = <<EOF
EOF
}