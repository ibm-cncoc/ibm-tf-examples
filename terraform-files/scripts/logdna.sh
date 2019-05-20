#!/usr/bin/env bash
export KUBECONFIG=${CONFIG}
# Making sure the namespace context is default since context is changed to the new namespace created through Terraform in namespace.sh file
kubectl config set-context $(kubectl config current-context) --namespace=default
kubectl create secret generic logdna-agent-key --from-literal=logdna-agent-key=${SERVICE_KEY}
kubectl create -f https://repo.logdna.com/ibm/prod/logdna-agent-ds-us-south.yaml
