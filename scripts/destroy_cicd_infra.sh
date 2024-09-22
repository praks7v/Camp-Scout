#!/bin/bash

# Print starting message
echo "Starting Terraform CICD destroy process..."

# Run Terraform to destroy infrastructure
cd ../terraform-gcp/environments/cicd
echo "Initializing Terraform for destruction..."
terraform init

echo "Destroying Terraform configuration..."
terraform destroy -auto-approve

# Remove the Terraform output JSON if it exists
if [ -f ../../../ansible/inventory/terraform_output.json ]; then
    echo "Removing Terraform output JSON..."
    rm ../../../ansible/inventory/terraform_output.json
fi

# Print completion message
echo "CICD environment destroyed successfully."

