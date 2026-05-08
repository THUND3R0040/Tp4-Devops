#!/bin/bash
set -e

echo "🚀 Applying Terraform changes..."

cd "$(dirname "$0")/../../environments/kubernetes-prod/01-cluster"

if [ ! -f "tfplan" ]; then
    echo "❌ No plan file found. Run ./scripts-k8s/01-cluster/plan.sh first"
    exit 1
fi

terraform apply tfplan

rm -f tfplan

echo ""
echo "✅ Infrastructure deployed successfully!"
echo ""