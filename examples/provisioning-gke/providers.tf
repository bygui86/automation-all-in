
# INFO: using 'google-beta' provider to enable 'gce_persistent_disk_csi_driver_config' beta feature
# provider "google" {
provider "google-beta" {
  credentials = file("terraform-gcp-service-account.json")

  project = var.gcp_project_id
  region  = var.gke_cluster_region
  zone    = var.gke_cluster_zone
}
