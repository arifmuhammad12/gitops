output "cluster_name" {
  value       = kind_cluster.default.name
  description = "Nama KinD Cluster yang berhasil diprovision"
}

output "kubeconfig" {
  value       = kind_cluster.default.kubeconfig
  sensitive   = true
  description = "Content dari Kubeconfig untuk terkoneksi ke cluster"
}

output "cluster_endpoint" {
  value       = kind_cluster.default.endpoint
  description = "API Server Endpoint KinD cluster"
}
