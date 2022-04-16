#!/bin/bash
set -x
#terraform -chdir=infra/1_eks_cluster plan
#terraform -chdir=infra/1_eks_cluster apply -auto-approve
aws eks update-kubeconfig --name education-eks-0OW0bXHL

#Creaing NS
kubectl create namespace dev
kubectl create namespace prod
kubectl create namespace mon

#insall prometheus and grafana
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://charts.helm.sh/stable
helm repo update

helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack --namespace mon

#install metric server
kubectl apply -f ./k8s_metric_server --namespace=kube-system

#install my app
kubectl apply -f ./k8s --namespace dev

sleep 10
echo "Application url:"
kubectl get svc httpd -n dev -o  jsonpath="{.status.loadBalancer.ingress[*].hostname}"

#monitoring port-forward
kubectl port-forward -n mon $(kubectl get pods -n mon | grep grafana | awk '{print $1}') --address 0.0.0.0 3000


