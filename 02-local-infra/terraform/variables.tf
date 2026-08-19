variable "cluster_name" {
  type        = string
  default     = "devops-local-cluster"
  description = "Nama KinD Kubernetes Cluster lokal"
}

variable "node_image" {
  type        = string
  default     = "kindest/node:v1.32.2"
  description = "Versi image Kubernetes node KinD"
}
