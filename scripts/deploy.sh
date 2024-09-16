#!/bin/bash

# Run Terraform to create infrastructure
cd ../terraform-gcp/environments/dev
terraform init
terraform apply -auto-approve

# Export Terraform output to JSON
terraform output -json > ../../../ansible/inventory/terraform_output.json

# Run Ansible playbook using dynamic inventory
cd ../../../ansible
chmod +x inventory/terraform_inventory.py
./inventory/terraform_inventory.py
chmod +x ../scripts/add_known_hosts.sh
./../scripts/add_known_hosts.sh
ansible-playbook -i inventory/ansible_inventory.json playbooks/main.yml
