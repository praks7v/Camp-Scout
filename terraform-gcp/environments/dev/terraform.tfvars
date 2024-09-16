# VPC Network
project_id   = "praks-dev"
network_name = "dev-vpc"

# Subnet Names
public_subnet_prefix = "public-subnet"

# VM instances
instance_image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20240829"

region = "asia-south1"
zones  = ["asia-south1-a", "asia-south1-b", "asia-south1-c"]

ssh_user       = "ansible"
ssh_public_key = "/home/dev/.ssh/ansible_ed25519.pub"

vm_instances = [
  {
    name         = "jenkins-vm"
    machine_type = "e2-standard-2"
    zone         = "asia-south1-a"
    disk_size    = 20
  },
  {
    name         = "sonarqube-vm"
    machine_type = "e2-medium"
    zone         = "asia-south1-a"
    disk_size    = 15
  },
  {
    name         = "app-vm"
    machine_type = "e2-medium"
    zone         = "asia-south1-a"
    disk_size    = 20
  }
]