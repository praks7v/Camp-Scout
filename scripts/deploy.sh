#!/bin/bash

# Run Terraform to create infrastructure
cd ../terraform
terraform init
terraform apply -auto-approve

# Export Terraform output to JSON
terraform output -json > ../ansible/inventory/terraform_output.json

# Run Ansible playbook using dynamic inventory
cd ../ansible
ansible-playbook -i inventory/terraform_inventory.py playbooks/main.yml
