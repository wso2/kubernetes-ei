#!/bin/bash

# ------------------------------------------------------------------------
# Copyright 2019 WSO2, Inc. (http://wso2.com)
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
GREP=`which grep`
KUBERNETES_CLIENT=`which kubectl`
SED=`which sed`
TEST=`which test`

# methods
function echoBold () {
    ${ECHO} -e $'\e[1m'"${1}"$'\e[0m'
}

read -p "Do you have a WSO2 Subscription?(N/y)" -n 1 -r
${ECHO}

if [[ $REPLY =~ ^[Yy]$ ]]; then
    read -p "Enter Your WSO2 Username: " WSO2_SUBSCRIPTION_USERNAME
    ${ECHO}
    read -s -p "Enter Your WSO2 Password: " WSO2_SUBSCRIPTION_PASSWORD
    ${ECHO}

    HAS_SUBSCRIPTION=0

    if ! grep -q "imagePullSecrets" ../analytics/integrator-analytics-deployment.yaml; then

        if ! sed -i.bak -e 's|wso2/|docker.wso2.com/|' \
            ../analytics/integrator-analytics-deployment.yaml  \
            ../dashboard/integrator-server-dashboard-deployment.yaml \
            ../broker/message-broker-deployment.yaml \
            ../integrator/integrator-deployment.yaml; then
            echoBold "Could not configure to use the Docker image available at WSO2 Private Docker Registry (docker.wso2.com)"
            exit 1
        fi
        case "`uname`" in
        Darwin*)
            if ! sed -i.bak -e '/serviceAccount/a \
                \      imagePullSecrets:' \
                ../analytics/integrator-analytics-deployment.yaml  \
                ../dashboard/integrator-server-dashboard-deployment.yaml \
                ../broker/message-broker-deployment.yaml \
                ../integrator/integrator-deployment.yaml; then
                echoBold "Could not configure Kubernetes Docker image pull secret: Failed to create \"imagePullSecrets:\" attribute"
                exit 1
            fi

            if ! sed -i.bak -e '/imagePullSecrets/a \
                \      - name: wso2creds' \
                ../analytics/integrator-analytics-deployment.yaml  \
                ../dashboard/integrator-server-dashboard-deployment.yaml \
                ../broker/message-broker-deployment.yaml \
                ../integrator/integrator-deployment.yaml; then
                echoBold "Could not configure Kubernetes Docker image pull secret: Failed to create secret name"
                exit 1
            fi;;
        *)
            if ! sed -i.bak -e '/serviceAccount/a \      imagePullSecrets:' \
                ../analytics/integrator-analytics-deployment.yaml  \
                ../dashboard/integrator-server-dashboard-deployment.yaml \
                ../broker/message-broker-deployment.yaml \
                ../integrator/integrator-deployment.yaml; then
                echoBold "Could not configure Kubernetes Docker image pull secret: Failed to create \"imagePullSecrets:\" attribute"
                exit 1
            fi

            if ! sed -i.bak -e '/imagePullSecrets/a \      - name: wso2creds' \
                ../analytics/integrator-analytics-deployment.yaml  \
                ../dashboard/integrator-server-dashboard-deployment.yaml \
                ../broker/message-broker-deployment.yaml \
                ../integrator/integrator-deployment.yaml; then
                echoBold "Could not configure Kubernetes Docker image pull secret: Failed to create secret name"
                exit 1
            fi
        esac

    fi
elif [[ ${REPLY} =~ ^[Nn]$ || -z "${REPLY}" ]]; then
     HAS_SUBSCRIPTION=1

     if ! sed -i.bak -e '/imagePullSecrets:/d' -e '/- name: wso2creds/d' \
         ../analytics/integrator-analytics-deployment.yaml  \
         ../dashboard/integrator-server-dashboard-deployment.yaml \
         ../broker/message-broker-deployment.yaml \
         ../integrator/integrator-deployment.yaml; then
         echoBold "couldn't configure the \"- name: wso2creds\""
         exit 1
     fi

     if ! sed -i.bak -e 's|docker.wso2.com|wso2|' \
         ../analytics/integrator-analytics-deployment.yaml  \
         ../dashboard/integrator-server-dashboard-deployment.yaml \
         ../broker/message-broker-deployment.yaml \
         ../integrator/integrator-deployment.yaml; then
         echoBold "couldn't configure the docker.wso2.com"
         exit 1
     fi
else
     echoBold "Invalid option"
     exit 1
fi

# remove backup files
${TEST} -f ../analytics/*.bak && rm ../analytics/*.bak
${TEST} -f ../dashboard/*.bak && rm ../dashboard/*.bak
${TEST} -f ../integrator/*.bak && rm ../integrator/*.bak
${TEST} -f ../broker/*.bak && rm ../broker/*.bak

# create a new Kubernetes Namespace
${KUBERNETES_CLIENT} create namespace wso2

# create a new service account in 'wso2' Kubernetes Namespace
${KUBERNETES_CLIENT} create serviceaccount wso2svc-account -n wso2

# create a Kubernetes Secret for passing WSO2 Private Docker Registry credentials
if [[ ${HAS_SUBSCRIPTION} -eq 0 ]]; then
    # create a Kubernetes Secret for passing WSO2 Private Docker Registry credentials
    ${KUBERNETES_CLIENT} create secret docker-registry wso2creds --docker-server=docker.wso2.com --docker-username=${WSO2_SUBSCRIPTION_USERNAME} --docker-password=${WSO2_SUBSCRIPTION_PASSWORD} --docker-email=${WSO2_SUBSCRIPTION_USERNAME}
fi

# switch the context to new 'wso2' namespace
${KUBERNETES_CLIENT} config set-context $(${KUBERNETES_CLIENT} config current-context) --namespace=wso2

# create Kubernetes Role and Role Binding necessary for the Kubernetes API requests made from Kubernetes membership scheme
${KUBERNETES_CLIENT} create -f ../../rbac/rbac.yaml

# ConfigMaps
echoBold 'Creating ConfigMaps...'
${KUBERNETES_CLIENT} create configmap mb-conf --from-file=../confs/broker
${KUBERNETES_CLIENT} create configmap mb-conf-axis2 --from-file=../confs/broker/axis2/
${KUBERNETES_CLIENT} create configmap mb-conf-datasources --from-file=../confs/broker/datasources/

${KUBERNETES_CLIENT} create configmap integrator-conf --from-file=../confs/integrator/conf
${KUBERNETES_CLIENT} create configmap integrator-conf-axis2 --from-file=../confs/integrator/conf/axis2/
${KUBERNETES_CLIENT} create configmap integrator-conf-datasources --from-file=../confs/integrator/conf/datasources/

${KUBERNETES_CLIENT} create configmap ei-analytics-conf-worker --from-file=../confs/ei-analytics/conf/worker

${KUBERNETES_CLIENT} create configmap ei-analytics-dashboard-conf-dashboard --from-file=../confs/ei-analytics-dashboard/conf/dashboard

${KUBERNETES_CLIENT} create configmap mysql-dbscripts --from-file=../extras/confs/mysql/dbscripts/

echoBold 'Deploying the Kubernetes Services...'
${KUBERNETES_CLIENT} create -f ../extras/rdbms/mysql/mysql-service.yaml
${KUBERNETES_CLIENT} create -f ../broker/message-broker-service.yaml
${KUBERNETES_CLIENT} create -f ../analytics/integrator-analytics-service.yaml
${KUBERNETES_CLIENT} create -f ../integrator/integrator-service.yaml
${KUBERNETES_CLIENT} create -f ../integrator/integrator-gateway-service.yaml
${KUBERNETES_CLIENT} create -f ../dashboard/integrator-server-dashboard-service.yaml

echoBold 'Creating Azure storage classes'
${KUBERNETES_CLIENT} apply -f ../../../azure/rbac.yaml
${KUBERNETES_CLIENT} apply -f ../../../azure/storage-class.yaml
${KUBERNETES_CLIENT} apply -f ../../../azure/mysql-storage-class.yaml

# Persistent storage
echoBold 'Creating persistent volume and volume claim...'
${KUBERNETES_CLIENT} create -f ../broker/message-broker-volume-claim-azure.yaml
${KUBERNETES_CLIENT} create -f ../integrator/integrator-volume-claims-azure.yaml
# ${KUBERNETES_CLIENT} create -f ../volumes/persistent-volumes.yaml
${KUBERNETES_CLIENT} create -f ../extras/rdbms/mysql/mysql-persistent-volume-claim-azure.yaml
# ${KUBERNETES_CLIENT} create -f ../extras/rdbms/volumes/persistent-volumes.yaml
sleep 40s

# MySQL
echoBold 'Deploying WSO2 Integrator Databases...'
${KUBERNETES_CLIENT} create -f ../extras/rdbms/mysql/mysql-deployment.yaml
sleep 10s

# Integrator
echoBold 'Deploying WSO2 Integrator, Broker and Analytics profiles...'
${KUBERNETES_CLIENT} create -f ../broker/message-broker-deployment.yaml
sleep 50s

${KUBERNETES_CLIENT} create -f ../analytics/integrator-analytics-deployment.yaml
${KUBERNETES_CLIENT} create -f ../dashboard/integrator-server-dashboard-deployment.yaml
sleep 4m

${KUBERNETES_CLIENT} create -f ../integrator/integrator-deployment.yaml
sleep 30s

echoBold 'Deploying Ingresses...'
${KUBERNETES_CLIENT} create -f ../ingresses/message-broker-ingress.yaml
${KUBERNETES_CLIENT} create -f ../ingresses/integrator-ingress.yaml
${KUBERNETES_CLIENT} create -f ../ingresses/integrator-gateway-ingress.yaml
${KUBERNETES_CLIENT} create -f ../ingresses/integrator-server-dashboard-ingress.yaml
sleep 30s

echoBold 'Finished'
echoBold 'To access the WSO2 Enterprise Integrator management console, try https://wso2ei-integrator/carbon in your browser.'
echoBold 'To access the WSO2 Enterprise Integrator Broker management console, try https://wso2ei-broker/carbon in your browser.'
echoBold 'To access the WSO2 Enterprise Integrator Analytics management console, try https://wso2ei-analytics-dashboard/portal in your browser.'
