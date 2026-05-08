#!/bin/bash
set -e

echo "Planning Terraform changes..."

cd "$(dirname "$0")/../../environments/kubernetes-prod/01-cluster"

terraform plan -out=tfplan

echo ""
echo "Plan saved to tfplan"
echo ""
echo "To apply these changes, run: ./scripts-k8s/01-cluster/apply.sh"