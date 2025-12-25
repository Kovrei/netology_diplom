terraform init -backend-config secret.backend.tfvars

ansible-playbook -i ./inventory/mycluster/hosts.yaml --become --become-user=root cluster.yml
kubectl get node
kubectl get pods --all-namespaces
cd ../terraform
export API_ENDPOINT=$(terraform output -raw api_endpoint)
mkdir -p ~/.kube && ssh ubuntu@158.160.48.68 "sudo cat /root/.kube/config" >> ~/.kube/config
nano .kube/config
kubectl get node
kubectl get pods --all-namespaces

docker build -t rei169kov/nginx:v1 .
docker run -d -p 80:80 rei169kov/nginx:v1
docker login docker.github.com -u
docker pull rei169kov/nginx:v1

####
#helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
#helm show values prometheus-community/kube-prometheus-stack > ./k8s/prometheus-values.yaml
#cd k8s
#sed -i '/portName: http-web/a\    type: NodePort\    \n    nodePort: 30050' prometheus-values.yaml
#helm upgrade --install monitoring prometheus-community/kube-prometheus-stack --create-namespace -n monitoring -f prometheus-values.yaml
#kubectl --namespace monitoring get secrets monitoring-grafana -o jsonpath="{.data.admin-password}" | base64 -d ; echo
#kubectl get po -n monitoring -o wide
#kubectl get svc -n monitoring -o wide
####
#kubectl create namespace diplom
#kubectl apply -f deployment.yaml -f service.yaml -n diplom
#kubectl get pods -n diplom
#kubectl get svc -A
####
#helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
#helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx   --namespace ingress-nginx   --create-namespace   -f ingress-values.yaml
#kubectl apply -f ingress-config.yaml
#kubectl get pods -n ingress-nginx
#kubectl get svc -n ingress-nginx
###
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install kube-prometheus prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace
kubectl get secret --namespace monitoring -l app.kubernetes.io/component=admin-secret -o jsonpath="{.items[0].data.admin-password}" | base64 --decode ; echo
kubectl get pods -o wide -n monitoring
kubectl apply -f namespace.yaml -f deployment.yaml -f service.yaml
kubectl get po -n diplom-nginx -o wide
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install my-nginx-ingress-controller ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace --set controller.hostNetwork=true --set controller.service.enabled=false
kubectl apply -f grafana-ingress.yaml  -f app-ingress.yaml
KUBE_EDITOR="nano" kubectl -n monitoring edit cm kube-prometheus-grafana
###
[server]
domain = 158.160.48.68
root_url = http://158.160.48.68/monitor/
serve_from_sub_path = true
###
kubectl -n monitoring rollout restart deploy/kube-prometheus-grafana
kubectl get svc -A
kubectl get po -n diplom-nginx -o wide
kubectl get po -n ingress-nginx -o wide
kubectl get pods -o wide -n monitoring
kubectl get pods -o wide -n atlantis

###
helm uninstall prometheus-stack -n monitoring
kubectl delete namespace monitoring
