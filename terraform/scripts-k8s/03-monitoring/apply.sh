#!/bin/bash
set -e

echo "🚀 Applying Terraform changes..."

cd "$(dirname "$0")/../../environments/kubernetes-prod/03-monitoring"

if [ ! -f "tfplan" ]; then
    echo "❌ No plan file found. Run ./scripts-k8s/03-monitoring/plan.sh first"
    exit 1
fi

terraform apply tfplan

rm -f tfplan

echo ""
echo "✅ Infrastructure deployed successfully!"
echo ""