#!/bin/bash
#set -x
set -e
#terraform -chdir=infra/00_cluster plan
#terraform -chdir=infra/00_cluster apply -auto-approve
echo "1. Getting the eks configuration..."
aws eks update-kubeconfig --name $(aws eks list-clusters | jq -r '.clusters[]') 1>/dev/null && 
echo "done"

#Creaing NS
echo "2. Creating namespaces in k8s..."
kubectl create namespace argocd 1>/dev/null
kubectl create namespace dev 1>/dev/null
kubectl create namespace prod 1>/dev/null
kubectl create namespace mon 1>/dev/null && 
echo "done"

#insall prometheus and grafana
echo "3. Installing prometheus and grafana k8s..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts 1>/dev/null
helm repo add stable https://charts.helm.sh/stable 1>/dev/null
helm repo update 1>/dev/null 

helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack --namespace mon 1>/dev/null && 
echo "done"

#install argocd
echo "4. Installing argocd in k8s..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml 1>/dev/null
#kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}' 1>/dev/null && 
echo "done"

#install metric server
echo "5. Installing metric server k8s..."
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml --namespace=kube-system 1>/dev/null && 
echo "done"

#install in dev namespace
echo "6. Deploy app in dev namespace..."
kustomize build kustomize/overlays/dev/frontend | kubectl apply -f -
kustomize build kustomize/overlays/dev/backend | kubectl apply -f -
#ubectl apply -f ./k8s/app --namespace dev 1>/dev/null && 
echo "done"

# #install in prod namespace
# echo "7. Deploy app in prod namespace..."
# kustomize build . | kubectl apply -f -
# kubectl apply -f ./k8s/app --namespace prod 1>/dev/null && 
# echo "done"

#Wainting for elb address:
echo "8. Waiting for elb address..."
sleep 10

#monitoring port-forward
echo "9. Port-forward grafana and argocd..." 
kubectl port-forward -n mon $(kubectl get pods -n mon | grep grafana | awk '{print $1}') --address 0.0.0.0 3000 &
kubectl port-forward -n argocd svc/argocd-server  8080:443 &
#echo "ARGOCD url:" "$(kubectl get svc argocd-server -n argocd -o jsonpath="{.status.loadBalancer.ingress[*].hostname}")"

echo "DEV Application url:" "$(kubectl get svc httpd -n dev -o  jsonpath="{.status.loadBalancer.ingress[*].hostname}")"
#echo "PROD Application url:" "$(kubectl get svc httpd -n prod -o  jsonpath="{.status.loadBalancer.ingress[*].hostname}")" 
echo "Grafana URL:" "http://localhost:3000/"
echo "ARGOCD URL:" "http://localhost:8080/"
echo "ARGOCD PASSWD:" "$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)"