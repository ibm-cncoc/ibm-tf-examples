# Export Kubernetes cluster config so that this shell can access the cluster
export KUBECONFIG=${CONFIG}

# Create Tiller ServiceAccount and ClusterRoleBinding
#kubectl apply -f https://raw.githubusercontent.com/IBM-Cloud/kube-samples/master/rbac/serviceaccount-tiller.yaml

# Patch Tiller ServiceAccount to the Tiller Deployment
# kubectl --namespace kube-system patch deploy tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'

# Install CRDs for cert-manager Helm chart
kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.8/deploy/manifests/00-crds.yaml --validate=false

# Creae cert-manager namespace and label it
kubectl create namespace cert-manager
kubectl label namespace cert-manager certmanager.k8s.io/disable-validation="true"