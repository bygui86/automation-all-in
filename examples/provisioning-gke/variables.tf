
variable "gcp_project_id" {
  description = "GCP project ID"
}

variable "gke_cluster_name" {
  default     = "kafka-challenge"
  description = "GKE cluster name"
}

variable "gke_cluster_region" {
  default     = "europe-west1"
  description = "GKE cluster region"
}

variable "gke_cluster_zone" {
  default     = "europe-west1-b"
  description = "GKE cluster zone"
}

variable "gke_k8s_version" {
  default     = "1.17.14-gke.1600"
  description = "GKE Kubernetes version"
}

variable "gke_num_nodes" {
  default     = 3
  description = "number of GKE nodes in default-pool"
}

variable "gke_machine_type" {
  # default     = "n1-standard-1" # 1 cpu + 3.75 gb ram
  default     = "custom-8-12288" # 8 cpu + 12 gb ram
  description = "GKE machine type"
}
