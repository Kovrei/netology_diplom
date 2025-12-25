#!/bin/bash

########################
echo "Initializing Terraform module..."
#terraform -chdir=backend init
terraform -chdir=backend init

echo "Applying configuration..."
terraform -chdir=backend apply -auto-approve

echo "Configuration saved to backend.tf"
echo "Run 'terraform init' in your main project directory to use the new backend."

##########################
echo "Initializing service_acc..."
#terraform -chdir=backend init
terraform -chdir=service_acc init

echo "Applying configuration service_acc..."
terraform -chdir=service_acc apply -auto-approve

echo "Configuration saved to sa.tf"

#########################
echo "Initializing Terraform module..."
#terraform -chdir=terraform init
terraform -chdir=terraform init -backend-config secret.backend.tfvars

echo "Applying configuration..."
terraform -chdir=terraform apply -auto-approve