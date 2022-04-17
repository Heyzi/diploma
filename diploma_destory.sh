#!/bin/bash
#set -x
set -e
#terraform -chdir=infra/1_eks_cluster plan
#terraform -chdir=infra/1_eks_cluster apply -auto-approve

#delete in dev namespace
echo "1. Delete app in dev namespace..."
kubectl delete -f ./k8s/app --namespace dev 1>/dev/null && 
echo "done"

#deelte in prod namespace
echo "2. Delete app in prod namespace..."
kubectl delete -f ./k8s/app --namespace prod 1>/dev/null && 
echo "done"
#
echo "3. TF infra destroy"
terraform -chdir=infra/0_eks_cluster plan
terraform -chdir=infra/0_eks_cluster destroy -auto-approve










