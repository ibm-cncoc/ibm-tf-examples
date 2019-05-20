#!/usr/bin/env bash
export KUBECONFIG=${CONFIG}


######### Remove network-insights agent #####
helm del --purge network-insights
kubectl delete ns security-advisor-insights

######### Remove activity-insights agent #####
helm del --purge activity-insights
kubectl delete ns security-advisor-insights