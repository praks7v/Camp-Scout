# VPC Network
module "network" {
  source                  = "../../modules/vpc-network"
  project_id              = var.project_id
  network_name            = var.network_name
  routing_mode            = "REGIONAL"
  description             = "BloggersUnity VPC Network"
  auto_create_subnetworks = false
  mtu                     = 1460
}

# VPC Subnet
resource "google_compute_subnetwork" "subnetwork" {
  project       = var.project_id
  name          = "prod-private-subnet"
  ip_cidr_range = "30.0.0.0/16"
  region        = var.region
  network       = module.network.network_name

  private_ip_google_access = false

  secondary_ip_range {
    range_name    = "k8s-pod-range"
    ip_cidr_range = "30.2.0.0/16"
  }
  secondary_ip_range {
    range_name    = "k8s-service-range"
    ip_cidr_range = "30.4.0.0/20"
  }
}

resource "google_compute_router" "router" {
  project = var.project_id
  name    = "router"
  region  = var.region
  network = module.network.network_name
}

# resource "google_compute_router_nat" "nat_gw" {
#   name    = "nat-gw"
#   project = var.project_id
#   router  = google_compute_router.router.name
#   region  = var.region

#   source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
#   nat_ip_allocate_option             = "MANUAL_ONLY"

#   subnetwork {
#     name                    = google_compute_subnetwork.subnetwork.id
#     source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
#   }

#   nat_ips = [google_compute_address.nat_ip.self_link]
# }

# resource "google_compute_address" "nat_ip" {
#   name         = "nat-ip"
#   project      = var.project_id
#   region       = var.region
#   address_type = "EXTERNAL"
#   network_tier = "PREMIUM"

# }


module "firewall" {
  source       = "../../modules/firewall"
  project_id   = var.project_id
  network_name = module.network.network_name

  ingress_rules = [
    {
      name          = "allow-ssh-cluser"
      description   = "Allow SSH from anywhere"
      priority      = 1000
      source_ranges = ["0.0.0.0/0"]
      allow = [
        {
          protocol = "tcp"
          ports    = ["22"]
        }
      ]
    }
  ]
}
