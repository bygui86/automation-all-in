
resource "google_container_cluster" "primary" {
  # INFO: using google-beta provider to enable 'gce_persistent_disk_csi_driver_config' beta feature
  provider = google-beta
  
  name                = var.gke_cluster_name
  location            = var.gke_cluster_zone
  initial_node_count  = var.gke_num_nodes
  min_master_version  = var.gke_k8s_version
  node_version        = var.gke_k8s_version
  release_channel {
    channel = "UNSPECIFIED"
  }

  # MISSING
  # --enable-autorepair
  # --no-enable-autoupgrade

  network    = "projects/${var.gcp_project_id}/global/networks/default"
  subnetwork = "projects/${var.gcp_project_id}/regions/${var.gke_cluster_region}/subnetworks/default"

  # DEFAULTS
  # logging_service = logging.googleapis.com/kubernetes
  # monitoring_service = monitoring.googleapis.com/kubernetes

  addons_config {
    # enabled by default
    horizontal_pod_autoscaling {
      disabled = false
    }
    # enabled by default
    http_load_balancing {
      disabled = false
    }
    # WARN: available only with google-beta provider
    gce_persistent_disk_csi_driver_config {
      enabled = true
    }
  }

  cluster_autoscaling {
      enabled = false
  }

  # If 'master_auth' block is provided and both username and password are empty, 
  # basic authentication will be disabled. (like gcloud --no-enable-basic-auth option)
  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  node_config {
    machine_type = var.gke_machine_type
    disk_type = "pd-ssd"
    image_type = "COS_CONTAINERD"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      # "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
    ]
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}
