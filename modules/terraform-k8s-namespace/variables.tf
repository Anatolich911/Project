variable "annotations" {
  type = map(any)
  default = {
    name = "example-annotation"
  }
}

variable "labels" {
  type = map(any)
  default = {
    name = "example-annotation"
  }
}

variable "name" {
  type    = string
  default = "terraform"
}

variable "pod_cpu" {
  type    = string
  default = "500m"
}

variable "pod_memory" {
  type    = string
  default = "2096Mi"
}

variable "storage_PVC" {
  type    = string
  default = "24M"
}

variable "container_cpu" {
  type    = string
  default = "500m"
}

variable "container_memory" {
  type    = string
  default = "2096Mi"
}
