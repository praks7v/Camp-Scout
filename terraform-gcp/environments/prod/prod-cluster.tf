# Google Container cluster
resource "google_container_cluster" "prod" {
  name                     = "prod-cluster"
  project                  = var.project_id
  location                 = var.zone
  remove_default_node_pool = true
  deletion_protection      = false
  initial_node_count       = 1
  network                  = module.network.network_name
  subnetwork               = google_compute_subnetwork.prod_subnet.self_link
  logging_service          = "logging.googleapis.com/kubernetes"
  monitoring_service       = "monitoring.googleapis.com/kubernetes"
  networking_mode = "VPC_NATIVE"

  addons_config {
    http_load_balancing {
      disabled = true
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "prod-pod-range"
    services_secondary_range_name = "prod-service-range"
  }

  private_cluster_config {
    enable_private_nodes    = false
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "40.16.0.0/28"
  }
}

# Service Account
resource "google_service_account" "kubernetes_prod" {
  account_id = "kubernetes-prod"
  project    = var.project_id
}

# Container Node Pool
resource "google_container_node_pool" "prod" {
  name       = "prod"
  project    = var.project_id
  cluster    = google_container_cluster.prod.id
  node_count = 1

  management {
    auto_repair  = true
    auto_upgrade = true
  }
  autoscaling {
    min_node_count = 1
    max_node_count = 6
  }

  node_config {
    preemptible  = false
    machine_type = "e2-medium"
    disk_type    = "pd-standard"
    disk_size_gb = 50

    labels = {
      role = "prod"
    }

    service_account = google_service_account.kubernetes_prod.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
