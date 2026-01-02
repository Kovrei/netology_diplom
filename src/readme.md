1 terraform init -backend-config secret.backend.tfvars

2 ansible-playbook -i ./inventory/mycluster/hosts.yaml --become --become-user=root cluster.yml
kubectl get node
kubectl get pods --all-namespaces
cd ../terraform
export API_ENDPOINT=$(terraform output -raw api_endpoint)
3 rm -rf .kube
4 mkdir -p ~/.kube && ssh ubuntu@51.250.3.123 "sudo cat /root/.kube/config" >> ~/.kube/config
sed -i 's/127.0.0.1/51.250.3.123/g' ~/.kube/config
5 nano .kube/config
kubectl get node
kubectl get pods --all-namespaces

docker build -t rei169kov/nginx:v1 .
docker run -d -p 80:80 rei169kov/nginx:1.0
docker login 
docker push rei169kov/nginx:1.0


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
domain = 178.154.224.111
root_url = http://178.154.224.111/monitor/
serve_from_sub_path = true
###
kubectl -n monitoring rollout restart deploy/kube-prometheus-grafana
kubectl get svc -A
kubectl get po -n diplom-nginx -o wide
kubectl get po -n ingress-nginx -o wide
kubectl get pods -o wide -n monitoring

kubectl apply -f atlantis_ns.yaml -f atlantis-secrets.yaml -f atlantis_cm.yaml -f atlantis_dt.yaml -f atlantis_svc.yaml
kubectl get pods -o wide -n atlantis



###
helm uninstall prometheus-stack -n monitoring
kubectl delete namespace monitoring
