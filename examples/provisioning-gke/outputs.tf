
output "gcp_project_id" {
  value       = var.gcp_project_id
  description = "GCP project ID"
}

output "gke_cluster_name" {
  value       = var.gke_cluster_name
  description = "GKE Cluster Name"
}

output "gke_cluster_region" {
  value       = var.gke_cluster_region
  description = "GKE cluster region"
}

output "gke_cluster_zone" {
  value       = var.gke_cluster_zone
  description = "GKE cluster zone"
}
