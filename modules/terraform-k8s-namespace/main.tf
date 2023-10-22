resource "kubernetes_namespace" "example" {
  metadata {
    annotations = var.annotations
    labels      = var.labels
    name        = var.name
  }
}

# resource "kubernetes_limit_range" "example" {
#   metadata {
#     name      = var.name
#     namespace = kubernetes_namespace.example.metadata[0].name
#   }
#   spec {
#     limit {
#       type = "Pod"
#       max = {
#         cpu    = var.pod_cpu
#         memory = var.pod_memory
#       }
#     }
#     limit {
#       type = "PersistentVolumeClaim"
#       min = {
#         storage = var.storage_PVC
#       }
#     }
#     limit {
#       type = "Container"
#       default = {
#         cpu    = var.container_cpu
#         memory = var.container_memory
#       }
#     }
#   }
# }


# resource "kubernetes_resource_quota" "example" {
#   metadata {
#     name      = var.name
#     namespace = kubernetes_namespace.example.metadata[0].name
#   }
#   spec {
#     hard = {
#       pods = 200
#     }
#     scopes = ["BestEffort"]
#   }
# }
