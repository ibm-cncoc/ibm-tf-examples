#!/usr/bin/env bash
# Export Kubernetes cluster config so that this shell can access the cluster
export KUBECONFIG=${CONFIG}

# Delete Tiller ServiceAccount and ClusterRoleBinding
kubectl delete -f https://raw.githubusercontent.com/IBM-Cloud/kube-samples/master/rbac/serviceaccount-tiller.yaml
