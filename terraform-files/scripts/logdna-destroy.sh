#!/usr/bin/env bash
export KUBECONFIG=${CONFIG}
# Making sure the namespace context is default since context is changed to the new namespace created through Terraform in namespace.sh file
kubectl config set-context $(kubectl config current-context) --namespace=default
kubectl delete secret logdna-agent-key 
kubectl delete -f https://repo.logdna.com/ibm/prod/logdna-agent-ds-us-south.yaml
