#!/bin/bash
set -e

echo "Running terraform init in root directory"
terraform init
echo "Running terraform test in root directory"
terraform test

cd modules

for dir in */; do
    cd "$dir" || continue 
    if [ -f "main.tf" ]; then
        echo "Running terraform init in $dir"
        terraform init
        echo "Running terraform test in $dir"
        terraform test
    else
        echo "$dir is not a Terraform module, skipping..."
    fi
    cd ..
done
