#!/bin/bash
set -e

echo "Initializing Terraform..."

cd "$(dirname "$0")/../../environments/kubernetes-prod/01-cluster"

terraform init

echo "Terraform initialized successfully!"
echo ""
echo "Next steps:"
echo "  1. Update terraform.tfvars with your values"
echo "  2. Run: ./scripts-k8s/01-cluster/plan.sh"
echo "  3. Review the plan"
echo "  4. Run: ./scripts-k8s/01-cluster/apply.sh"