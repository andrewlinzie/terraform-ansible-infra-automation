#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/write_inventory.sh /absolute/path/to/private_key
# Requires: Terraform already applied
KEY_PATH="${1:-}"
if [[ -z "${KEY_PATH}" ]]; then
  echo "ERROR: Please supply the ABSOLUTE path to your PRIVATE key as the first argument."
  echo "Example: ./scripts/write_inventory.sh /Users/you/.ssh/tc3"
  exit 1
fi

# Read the public IP from Terraform outputs
EC2_IP=$(terraform -chdir=terraform output -raw public_ip)

cat > ansible/inventory.ini <<EOF
[web]
web ansible_host=${EC2_IP} ansible_user=ubuntu ansible_ssh_private_key_file=${KEY_PATH}
EOF

echo "Wrote ansible/inventory.ini:"
cat ansible/inventory.ini
