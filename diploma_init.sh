#!/bin/bash
#set -x
set -e
#terraform -chdir=infra/00_cluster plan
#terraform -chdir=infra/00_cluster apply -auto-approve

#eksctl create cluster -f infra/02_eksctl/cluster.yaml

echo "1. Getting the eks configuration..."
aws eks update-kubeconfig --name $(aws eks list-clusters | jq -r '.clusters[]') 1>/dev/null && 
echo "done"

#https://docs.aws.amazon.com/eks/latest/userguide/autoscaling.html
echo "2 Enable cluster scaling"
kubectl apply -f infra/02_eksctl/cluster-scale.yaml  1>/dev/null && 
echo "done"

#Creaing NS
echo "3. Creating namespaces in k8s..."
for i in argocd dev prod mon; do kubectl create namespace $i; done
echo "done"

#insall prometheus and grafana
echo "4. Installing prometheus, grafana..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts 1>/dev/null
#loki
helm repo add grafana https://grafana.github.io/helm-charts  1>/dev/null
helm repo add stable https://charts.helm.sh/stable 1>/dev/null
helm repo update 1>/dev/null 

helm upgrade --install loki grafana/loki-stack --namespace mon 1>/dev/null 
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack --namespace mon 1>/dev/null && 
echo "done"

#install argocd
echo "5. Installing argocd in k8s..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml 1>/dev/null
##kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}' 1>/dev/null && 
echo "done"

#install metric server
echo "6. Installing metric server k8s..."
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml --namespace=kube-system 1>/dev/null 
kubectl patch deployment metrics-server -n kube-system --type 'json' -p '[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]'
echo "done"

#install in dev namespace
echo "7. Deploy app and secrets in dev namespace..."

# kubectl create secret generic config \
#  --from-env-file ./env_dev -ndev \
#  --dry-run=client --output=yaml > kustomize/overlays/dev/backend/secrets.yaml
kubectl create secret generic config \
 --from-env-file ./env_dev -ndev 1>/dev/null 

kustomize build kustomize/overlays/dev/frontend | kubectl apply -f - 1>/dev/null 
kustomize build kustomize/overlays/dev/backend | kubectl apply -f - 1>/dev/null 

echo "done"

#install in prod namespace
echo "8. Deploy app in prod namespace..."
# kubectl create secret generic config \
#  --from-env-file ./env_prod -nprod \
#  --dry-run=client --output=yaml > kustomize/overlays/prod/backend/secrets.yaml
kubectl create secret generic config \
 --from-env-file ./env_prod -nprod \

kustomize build kustomize/overlays/prod/frontend | kubectl apply -f - 1>/dev/null 
kustomize build kustomize/overlays/prod/backend | kubectl apply -f -  1>/dev/null 
echo "done"

#Wainting for elb address:
echo "9. Waiting for elb address..."
sleep 10

#monitoring port-forward
echo "10. Port-forward grafana and argocd..." 
kubectl port-forward -n mon $(kubectl get pods -n mon | grep grafana | awk '{print $1}') --address 0.0.0.0 3000 &
kubectl port-forward -n argocd svc/argocd-server  8080:443 &
#echo "ARGOCD url:" "$(kubectl get svc argocd-server -n argocd -o jsonpath="{.status.loadBalancer.ingress[*].hostname}")"

echo "DEV Application url:" "$(kubectl get svc httpd -n dev -o  jsonpath="{.status.loadBalancer.ingress[*].hostname}")"
echo "PROD Application url:" "$(kubectl get svc httpd -n prod -o  jsonpath="{.status.loadBalancer.ingress[*].hostname}")"
echo "DB name:" "$(aws rds describe-db-instances| jq -r '.DBInstances[] | {DBInstanceIdentifier} | join(" ")')"
echo "DBHOST:" "$(aws rds describe-db-instances| jq -r '.DBInstances[].Endpoint| {Address} | join(" ")')"

echo "Grafana URL:" "http://localhost:3000/"
echo "ARGOCD URL:" "http://localhost:8080/"
echo "ARGOCD PASSWD:" "$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)"