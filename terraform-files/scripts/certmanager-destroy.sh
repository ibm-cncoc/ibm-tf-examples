#!/usr/bin/env bash
# Export Kubernetes cluster config so that this shell can access the cluster
export KUBECONFIG=${CONFIG}

# Delete CRDs for cert-manager Helm chart
kubectl delete -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.7/deploy/manifests/00-crds.yaml

# Delete cert-manager namespace 
kubectl delete namespace cert-manager
