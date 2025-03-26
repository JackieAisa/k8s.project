#!/bin/bash

# Get Terraform outputs
MASTER_IP=$(terraform output -raw rke_master_ip)
WORKER_IPS=$(terraform output -json rke_worker_ips | jq -r '.[]')

# Create Ansible inventory file
echo "[master]" > ansible/hosts
echo "${MASTER_IP}" >>ansible/ hosts

echo "[workers]" >> ansible/hosts
for ip in $WORKER_IPS; do
  echo "${ip}" >> ansible/hosts
done


# Create vars for ansible j2 file (NEED TO WORK ON WORKER_IP index.number)

echo "MASTER_IP: ${MASTER_IP}" >> vars/main.yaml

echo "WORKER1_IP:" >> vars/main.yaml
echo "${ip}" >> vars/main.yaml

echo "WORKER2_IP:" >> vars/main.yaml
echo "${ip}" >> vars/main.yaml



