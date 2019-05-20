#!/usr/bin/env bash
# Export Kubernetes cluster config so that this shell can access the cluster
export KUBECONFIG=${CONFIG}

# It should automatically be set to default namespace, but doing so anyways
kubectl config set-context $(kubectl config current-context) --namespace=default

# Getting each of the secrets and replacing them with the new namespace and creating them
kubectl get secret bluemix-default-secret -o yaml | sed "s/default/${NAMESPACE}/g" | kubectl -n ${NAMESPACE} create -f -
kubectl get secret bluemix-default-secret-international -o yaml | sed "s/default/${NAMESPACE}/g" | kubectl -n ${NAMESPACE} create -f -
kubectl get secret bluemix-default-secret-regional -o yaml | sed "s/default/${NAMESPACE}/g" | kubectl -n ${NAMESPACE} create -f -

# Switching back to the new namespace and patching the serviceaccount with the secrets created
kubectl config set-context $(kubectl config current-context) --namespace=${NAMESPACE}
kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "bluemix-'${NAMESPACE}'-secret"},{"name": "bluemix-'${NAMESPACE}'-secret-international"},{"name":"bluemix-'${NAMESPACE}'-secret-regional"}]}'
