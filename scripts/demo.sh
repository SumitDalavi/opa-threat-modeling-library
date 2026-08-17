#!/bin/bash
set -e

echo "================================================="
echo "   OPA / Rego Threat Modeling Demo"
echo "================================================="

echo "1. Running Rego Unit Tests..."
# Use docker to run OPA to avoid local installation issues
docker run --rm -v $(pwd):/workspace -w /workspace openpolicyagent/opa test policies/ -v

echo ""
echo "2. Evaluating 'Bad' Terraform Plan (Should trigger STRIDE violations)..."
docker run --rm -v $(pwd):/workspace -w /workspace openpolicyagent/opa eval -d policies/ -i data/tfplan_bad.json "data.terraform.analysis.deny"

echo ""
echo "3. Evaluating 'Good' Terraform Plan (Should be empty/clean)..."
docker run --rm -v $(pwd):/workspace -w /workspace openpolicyagent/opa eval -d policies/ -i data/tfplan_good.json "data.terraform.analysis.deny"

echo ""
echo "✅ Demo completed successfully!"
