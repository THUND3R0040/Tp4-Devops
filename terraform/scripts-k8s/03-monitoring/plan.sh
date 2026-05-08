#!/bin/bash
set -e

echo "Planning Terraform changes..."

cd "$(dirname "$0")/../../environments/kubernetes-prod/03-monitoring"

terraform plan -out=tfplan

echo ""
echo "Plan saved to tfplan"
echo ""
echo "To apply these changes, run: ./scripts-k8s/03-monitoring/apply.sh"