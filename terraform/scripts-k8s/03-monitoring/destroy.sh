#!/bin/bash
set -e

echo "⚠️  WARNING: This will destroy all infrastructure!"
read -p "Are you sure? Type 'yes' to continue: " confirm

if [ "$confirm" != "yes" ]; then
    echo "❌ Cancelled"
    exit 1
fi

cd "$(dirname "$0")/../../environments/kubernetes-prod/03-monitoring"

terraform destroy

echo "✅ Infrastructure destroyed"