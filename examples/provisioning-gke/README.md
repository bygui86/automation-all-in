
# The Kafka challenge - Provision the GKE Cluster

## Prerequisites

- GCloud SDK installed and configured (`gcloud init` and `gcloud auth`)
- GCP project already in place
- kubectl installed

## 1. Provision GCP service account

1. Go to the folder

    ```bash
    cd kafka-challenge-gke/1-provisioning-gke
    ```

1. Create GCP service account

    ```bash
    gcloud iam service-accounts create terraform --display-name terraform \
        --project $(gcloud config get-value project)
    ```

1. Assign GCP service account to GCP project with following required roles:

    - `Kubernetes Engine Cluster Admin`
    - `Service Account User` (for `iam.serviceAccountUser` permission)
    - `Compute Engine Service Agent` (for `compute.instanceGroupManagers.get` permission)

    ```bash
    gcloud projects add-iam-policy-binding $(gcloud config get-value project) \
        --member "serviceAccount:terraform@$(gcloud config get-value project).iam.gserviceaccount.com" \
        --role "roles/container.clusterAdmin" \
        --condition=None

    gcloud projects add-iam-policy-binding $(gcloud config get-value project) \
        --member "serviceAccount:terraform@$(gcloud config get-value project).iam.gserviceaccount.com" \
        --role "roles/iam.serviceAccountUser" \
        --condition=None

    gcloud projects add-iam-policy-binding $(gcloud config get-value project) \
        --member "serviceAccount:terraform@$(gcloud config get-value project).iam.gserviceaccount.com" \
        --role "roles/compute.serviceAgent" \
        --condition=None
    ```

1. Create and download GCP service account key file

    ```bash
    gcloud iam service-accounts keys create "terraform-gcp-service-account.json" \
        --iam-account "terraform@$(gcloud config get-value project).iam.gserviceaccount.com"
    ```

## 2. Provision GKE Cluster

1. Go to the folder

    ```bash
    cd kafka-challenge-gke/1-provisioning-gke
    ```

1. Get GCP project ID and replace `gcp_project_id` value in `terraform.tfvars`

    ```bash
    sed -i "s|%GCP_PROJECT_ID%|$(gcloud config get-value project)|g" terraform.tfvars
    ```

1. Initalize Terraform workspace, which will download the provider and initialize it with the values provided in the `terraform.tfvars` file

    ```bash
    terraform init
    ```

1. Check if Terraform scripts are right

    ```bash
    terraform plan
    ```

1. Provision GKE cluster

    ```bash
    terraform apply -auto-approve
    ```

    Expected output:
    ```log
    # omitted logs

    Apply complete! Resources: 1 added, 0 changed, 1 destroyed.

    Outputs:

    gcp_project_id = "gifted-relic-300720"
    gke_cluster_name = "kafka-challenge"
    gke_cluster_region = "europe-west1"
    gke_cluster_zone = "europe-west1-b"
    ```

1. Configure kubectl to connect to the new GKE cluster

    ```shell
    gcloud container clusters get-credentials kafka-challenge --zone europe-west1-b
    ```

    `GCP_PROJECT_ID` corresponds to Terraform output `gcp_project_id` obtained in the previous step.

## 3. Cleanup

### Delete GKE cluster

1. Go to the folder

    ```bash
    cd kafka-challenge-gke/1-provisioning-gke
    ```

1. Run Terraform destroy command

    ```bash
    terraform destroy -auto-approve
    ```

### Delete GCP service account

1. Run following command

    ```bash
    gcloud iam service-accounts delete terraform \
        --project $(gcloud config get-value project)
    ```

---

## Links

- [Provision a GKE Cluster learn guide](https://learn.hashicorp.com/terraform/kubernetes/provision-gke-cluster)

- Terraform registry
  - https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/- provider_versions
  - https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/- using_gke_with_terraform
  - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster
  - https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/latest
