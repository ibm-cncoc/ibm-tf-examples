#!/usr/bin/env bash
export KUBECONFIG=${CONFIG}

################### Network Insights Agent Install ###################

# Get the tar file for network insights agent and execute the script that installs the agent helm chart
wget https://raw.githubusercontent.com/ibm-cloud-security/security-advisor-network-insights/master/v1.10%2B/security-advisor-network-insights.tar
tar -xvf security-advisor-network-insights.tar 
cd security-advisor-network-insights 
yes | ./network-insight-install.sh ${COS_REGION} ${COS_API_KEY} # Use `yes` to prevent prompts (allows install without enabling TLS)

# verify install
helm ls | grep network-insights
kubectl get pods -n security-advisor-insights | grep network-insights

# After successful install, remove files that are created 
cd ..
rm -R ./security-advisor-network-insights
rm ./security-advisor-network-insights.tar


################### Activity Insights Agent Install ###########################
wget https://raw.githubusercontent.com/ibm-cloud-security/security-advisor-activity-insights/master/security-advisor-activity-insights.tar
tar -xvf security-advisor-activity-insights.tar
cd security-advisor-activity-insights 
yes | ./activity-insight-install.sh ${COS_REGION} ${COS_API_KEY} ${AT_REGION} ${ACCOUNT_API_KEY} ${SPACE_GUID}

# verify install
helm ls | grep activity-insights
kubectl get pods -n security-advisor-insights | grep activity-insights

# After successful install, remove files that are created 
cd ..
rm -R ./security-advisor-activity-insights
rm ./security-advisor-activity-insights.tar