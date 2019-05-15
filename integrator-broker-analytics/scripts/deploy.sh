#!/bin/bash

# ------------------------------------------------------------------------
# Copyright 2017 WSO2, Inc. (http://wso2.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License
# ------------------------------------------------------------------------

set -e

ECHO=`which echo`
KUBECTL=`which kubectl`

# methods
function echoBold () {
    ${ECHO} -e $'\e[1m'"${1}"$'\e[0m'
}

function usage () {
    echoBold "This script automates the installation of WSO2 EI Integrator Analytics Kubernetes resources\n"
    echoBold "Allowed arguments:\n"
    echoBold "-h | --help"
    echoBold "--wu | --wso2-username\t\tYour WSO2 username"
    echoBold "--wp | --wso2-password\t\tYour WSO2 password"
    echoBold "--cap | --cluster-admin-password\tKubernetes cluster admin password\n\n"
}

read -p "Do you have a WSO2 Subscription?(N/y)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
 read -p "Enter Your WSO2 Username: " WSO2_SUBSCRIPTION_USERNAME
 echo
 read -s -p "Enter Your WSO2 Password: " WSO2_SUBSCRIPTION_PASSWORD
 echo
 HAS_SUBSCRIPTION=0
 if ! grep -q "imagePullSecrets" ../analytics/integrator-analytics-deployment.yaml; then
     if ! sed -i.bak -e 's|wso2/|docker.wso2.com/|' \
     ../analytics/integrator-analytics-deployment.yaml  \
     ../dashboard/integrator-server-dashboard-deployment.yaml \
     ../broker/message-broker-deployment.yaml \
     ../integrator/integrator-deployment.yaml; then
     echo "couldn't configure the docker.wso2.com"
     exit 1
     fi
     if ! sed -i.bak -e '/serviceAccount/a \
    \      imagePullSecrets:' \
     ../analytics/integrator-analytics-deployment.yaml  \
     ../dashboard/integrator-server-dashboard-deployment.yaml \
     ../broker/message-broker-deployment.yaml \
     ../integrator/integrator-deployment.yaml; then
     echo "couldn't configure the \"imagePullSecrets:\""
     exit 1
     fi
      if ! sed -i.bak -e '/imagePullSecrets/a \
    \      - name: wso2creds' \
     ../analytics/integrator-analytics-deployment.yaml  \
     ../dashboard/integrator-server-dashboard-deployment.yaml \
     ../broker/message-broker-deployment.yaml \
     ../integrator/integrator-deployment.yaml; then
     echo "couldn't configure the \"- name: wso2creds\""
     exit 1
     fi
 fi
elif [[ $REPLY =~ ^[Nn]$ || -z "$REPLY" ]]
then
 HAS_SUBSCRIPTION=1
 if ! sed -i.bak -e '/imagePullSecrets:/d' -e '/- name: wso2creds/d' \
     ../analytics/integrator-analytics-deployment.yaml  \
     ../dashboard/integrator-server-dashboard-deployment.yaml \
     ../broker/message-broker-deployment.yaml \
     ../integrator/integrator-deployment.yaml; then
     echo "couldn't configure the \"- name: wso2creds\""
     exit 1
 fi
 if ! sed -i.bak -e 's|docker.wso2.com|wso2|' \
     ../analytics/integrator-analytics-deployment.yaml  \
     ../dashboard/integrator-server-dashboard-deployment.yaml \
     ../broker/message-broker-deployment.yaml \
     ../integrator/integrator-deployment.yaml; then
  echo "couldn't configure the docker.wso2.com"
  exit 1
 fi
else
 echo "Invalid option"
 exit 1
fi

# remove backup files
test -f ../analytics/*.bak && rm ../analytics/*.bak
test -f ../dashboard/*.bak && rm ../dashboard/*.bak
test -f ../integrator/*.bak && rm ../integrator/*.bak
test -f ../broker/*.bak && rm ../broker/*.bak

# create a new Kubernetes Namespace
${KUBECTL} create namespace wso2

# create a new service account in 'wso2' Kubernetes Namespace
${KUBECTL} create serviceaccount wso2svc-account -n wso2

# switch the context to new 'wso2' namespace
${KUBECTL} config set-context $(${KUBECTL} config current-context) --namespace=wso2


# create a Kubernetes Secret for passing WSO2 Private Docker Registry credentials
if [ ${HAS_SUBSCRIPTION} -eq 0 ]; then
${KUBECTL} create secret docker-registry wso2creds --docker-server=docker.wso2.com --docker-username=${WSO2_SUBSCRIPTION_USERNAME} --docker-password=${WSO2_SUBSCRIPTION_PASSWORD} --docker-email=${WSO2_SUBSCRIPTION_USERNAME}
fi

# create Kubernetes Role and Role Binding necessary for the Kubernetes API requests made from Kubernetes membership scheme
${KUBECTL} create -f ../../rbac/rbac.yaml

# ConfigMaps
echoBold 'Creating ConfigMaps...'
${KUBECTL} create configmap mb-conf --from-file=../confs/broker
${KUBECTL} create configmap mb-conf-axis2 --from-file=../confs/broker/axis2/
${KUBECTL} create configmap mb-conf-datasources --from-file=../confs/broker/datasources/

${KUBECTL} create configmap integrator-conf --from-file=../confs/integrator/conf
${KUBECTL} create configmap integrator-conf-axis2 --from-file=../confs/integrator/conf/axis2/
${KUBECTL} create configmap integrator-conf-datasources --from-file=../confs/integrator/conf/datasources/
${KUBECTL} create configmap integrator-conf-event-publishers --from-file=../confs/integrator/repository/deployment/server/eventpublishers/

${KUBECTL} create configmap ei-analytics-conf-worker --from-file=../confs/ei-analytics/conf/worker

${KUBECTL} create configmap ei-analytics-dashboard-conf-dashboard --from-file=../confs/ei-analytics-dashboard/conf/dashboard

${KUBECTL} create configmap mysql-dbscripts --from-file=../extras/confs/mysql/dbscripts/

echoBold 'Deploying the Kubernetes Services...'
${KUBECTL} create -f ../extras/rdbms/mysql/mysql-service.yaml
${KUBECTL} create -f ../broker/message-broker-service.yaml
${KUBECTL} create -f ../analytics/integrator-analytics-service.yaml
${KUBECTL} create -f ../integrator/integrator-service.yaml
${KUBECTL} create -f ../integrator/integrator-gateway-service.yaml
${KUBECTL} create -f ../dashboard/integrator-server-dashboard-service.yaml

# MySQL
echoBold 'Deploying WSO2 Integrator Databases...'
${KUBECTL} create -f ../extras/rdbms/mysql/mysql-deployment.yaml
sleep 10s

# Persistent storage
echoBold 'Creating persistent volume and volume claim...'
${KUBECTL} create -f ../broker/message-broker-volume-claim.yaml
${KUBECTL} create -f ../integrator/integrator-volume-claims.yaml
${KUBECTL} create -f ../volumes/persistent-volumes.yaml
${KUBECTL} create -f ../extras/rdbms/mysql/mysql-persistent-volume-claim.yaml
${KUBECTL} create -f ../extras/rdbms/volumes/persistent-volumes.yaml
sleep 40s

# Integrator
echoBold 'Deploying WSO2 Integrator, Broker and Analytics profiles...'
${KUBECTL} create -f ../broker/message-broker-deployment.yaml
sleep 50s

${KUBECTL} create -f ../analytics/integrator-analytics-deployment.yaml
${KUBECTL} create -f ../dashboard/integrator-server-dashboard-deployment.yaml
sleep 4m

${KUBECTL} create -f ../integrator/integrator-deployment.yaml
sleep 30s

echoBold 'Deploying Ingresses...'
${KUBECTL} create -f ../ingresses/message-broker-ingress.yaml
${KUBECTL} create -f ../ingresses/integrator-ingress.yaml
${KUBECTL} create -f ../ingresses/integrator-gateway-ingress.yaml
${KUBECTL} create -f ../ingresses/integrator-server-dashboard-ingress.yaml
sleep 30s

echoBold 'Finished'
echo 'To access the WSO2 Enterprise Integrator management console, try https://wso2ei-integrator/carbon in your browser.'
echo 'To access the WSO2 Enterprise Integrator Broker management console, try https://wso2ei-broker/carbon in your browser.'
echo 'To access the WSO2 Enterprise Integrator Analytics management console, try https://wso2ei-analytics-dashboard/portal in your browser.'
