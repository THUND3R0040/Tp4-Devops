#!/bin/bash
set -e

echo "Initializing Terraform..."

cd "$(dirname "$0")/../../environments/kubernetes-prod/02-ingress"

terraform init

echo "Terraform initialized successfully!"
echo ""
echo "Next steps:"
echo "  1. Update terraform.tfvars with your values"
echo "  2. Run: ./scripts-k8s/02-ingress/plan.sh"
echo "  3. Review the plan"
echo "  4. Run: ./scripts-k8s/02-ingress/apply.sh"