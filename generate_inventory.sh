#!/bin/bash

# Get Terraform outputs
MASTER_IP=$(terraform output -raw rke_master_ip)
WORKER_IPS=$(terraform output -json rke_worker_ips | jq -r '.[]')

# Create Ansible inventory file
echo "[master]" > hosts
echo "master ansible_host=${MASTER_IP}" >> hosts

echo "[workers]" >> hosts
for ip in $WORKER_IPS; do
  echo "worker ansible_host=${ip}" >> hosts
done