#!/bin/bash
#set -x
set -e
#terraform -chdir=infra/1_eks_cluster plan
#terraform -chdir=infra/1_eks_cluster apply -auto-approve

#delete in dev namespace
echo "1. Delete app in dev namespace..."
kustomize build kustomize/overlays/dev/frontend | kubectl delete -f - 1>/dev/null && 
echo "done"

#delete in prod namespace
echo "2. Delete app in prod namespace..."
kustomize build kustomize/overlays/prod/frontend | kubectl apply -f -  1>/dev/null && 
echo "done"
#
echo "3. infra destroy"
# terraform -chdir=infra/01_eks_cluster plan
# terraform -chdir=infra/01_eks_cluster destroy -auto-approve
eksctl delete cluster -f infra/02_eksctl/cluster.yaml










