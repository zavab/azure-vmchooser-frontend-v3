#!/bin/bash
workload=$1
environment=$2
namespace=$3 
version=$4
chart=$5
deploymentname=$6 
valuesfile=$7
helmregistry=$5
component='www'
az extension add --name resource-graph

# functions
function getClusterName {
  temp=`az graph query -q "Resources | where type =~ \"Microsoft.ContainerService/ManagedClusters\" | where properties.provisioningState =~ \"Succeeded\" | where tags[\"Environment\"] =~ \"$environment\" | where tags[\"Workload\"] =~ \"$workload\" | project name" -o yaml | awk '{ print $3 }'`
  echo $temp
}

function getClusterResourcegroup {
  temp=`az graph query -q "Resources | where type =~ \"Microsoft.ContainerService/ManagedClusters\" | where name =~ \"$1\" | project resourceGroup" -o yaml | awk '{ print $3 }'`
  echo $temp
}

function getClusterKubectl { 
  temp=`az aks get-credentials -g $2 -n $1`
  echo $temp
}

function deployToCluster {
  echo "Deploying to $1"
  clustername=$1
  clusterrg=$(getClusterResourcegroup $clustername)
  getClusterKubectl $clustername $clusterrg
  lastversion=`helm history "$deploymentname" | tail -n 1 | awk '{ print $1 }'`
  helm status "$deploymentname" | grep -i 'deployed' && action="upgrade" || action="install"
  cat $valuesfile
  helm $action "$deploymentname" "$helmregistry" --version "$version" -n "$namespace" -f "$valuesfile"
  RESULT=$?
  if [ $RESULT -eq 0 ]; then
    echo "Deploy succeeded!"
  else
    echo "Deploy failed. Trying rollback or delete deployment"
    helm rollback "$deploymentname" "$lastversion" || helm delete "$deploymentname"
    exit 1
  fi
}

function getTrafficManager {
  temp=`az graph query -q "Resources | where type =~ \"Microsoft.Network/trafficManagerProfiles\" | where tags[\"Component\"] =~ \"$component\" | where tags[\"Environment\"] =~ \"$environment\" | where tags[\"Workload\"] =~ \"$workload\" | project name" -o yaml | awk '{ print $3 }'`
  echo $temp
}

function getTrafficManagerResourcegroup {
  temp=`az graph query -q "Resources | where type =~ \"Microsoft.Network/trafficManagerProfiles\" | where name =~ \"$1\" | project resourceGroup" -o yaml | awk '{ print $3 }'`
  echo $temp
}

function addService2TrafficeManager {
  servicename=`kubectl get services | grep -i "$deploymentname" | awk '{ print $1 }'`
    if [ -z "$servicename" ]; then
    echo "Service not deployed!"
    exit 255
  fi
  external_ip=""
  while [ -z $external_ip ]; do
    echo "Waiting for end point..."
    external_ip=$(kubectl get svc "$servicename" --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}")
    [ -z "$external_ip" ] && sleep 10
  done
  echo 'End point ready:' && echo $external_ip
  clustername=$1
  tmname=$(getTrafficManager)
  tmrg=$(getTrafficManagerResourcegroup $tmname)
  weight=1
  az network traffic-manager endpoint create --resource-group "$tmrg" --profile-name "$tmname" --type externalEndpoints --name "$clustername" --target "$external_ip" --weight $weight
}

# main runtime
## Install kubectl
sudo az aks install-cli
export PATH=$PATH:/usr/local/bin

## Discover Clusters 
clusters=$(getClusterName)  
for clustername in $clusters
do
  deployToCluster $clustername
done