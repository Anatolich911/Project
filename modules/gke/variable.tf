variable "gke_config" {
  type = map(any)
  default = {
  }
}

variable "preemptible" {
  type = bool
}
