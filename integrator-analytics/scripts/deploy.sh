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

WSO2_SUBSCRIPTION_USERNAME=''
WSO2_SUBSCRIPTION_PASSWORD=''
ADMIN_PASSWORD=''

# capture named arguments
while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`

    case ${PARAM} in
        -h | --help)
            usage
            exit 1
            ;;
        --wu | --wso2-username)
            WSO2_SUBSCRIPTION_USERNAME=${VALUE}
            ;;
        --wp | --wso2-password)
            WSO2_SUBSCRIPTION_PASSWORD=${VALUE}
            ;;
        --cap | --cluster-admin-password)
            ADMIN_PASSWORD=${VALUE}
            ;;
        *)
            echoBold "ERROR: unknown parameter \"${PARAM}\""
            usage
            exit 1
            ;;
    esac
    shift
done

# create a new Kubernetes Namespace
${KUBECTL} create namespace wso2

# create a new service account in 'wso2' Kubernetes Namespace
${KUBECTL} create serviceaccount wso2svc-account -n wso2

# switch the context to new 'wso2' namespace
${KUBECTL} config set-context $(${KUBECTL} config current-context) --namespace=wso2

# create a Kubernetes Secret for passing WSO2 Private Docker Registry credentials
#${KUBECTL} create secret docker-registry wso2creds --docker-server=docker.wso2.com --docker-username=${WSO2_SUBSCRIPTION_USERNAME} --docker-password=${WSO2_SUBSCRIPTION_PASSWORD} --docker-email=${WSO2_SUBSCRIPTION_USERNAME}

# create Kubernetes Role and Role Binding necessary for the Kubernetes API requests made from Kubernetes membership scheme
${KUBECTL} create --username=admin --password=${ADMIN_PASSWORD} -f ../../rbac/rbac.yaml

# create Kubernetes ConfigMaps
echoBold 'Creating ConfigMaps...'
${KUBECTL} create configmap integrator-conf --from-file=../confs/integrator/conf
${KUBECTL} create configmap integrator-conf-axis2 --from-file=../confs/integrator/conf/axis2/
${KUBECTL} create configmap integrator-conf-datasources --from-file=../confs/integrator/conf/datasources/
${KUBECTL} create configmap integrator-conf-event-publishers --from-file=../confs/integrator/repository/deployment/server/eventpublishers/

${KUBECTL} create configmap ei-analytics-1-conf-worker --from-file=../confs/ei-analytics-1/conf/worker

${KUBECTL} create configmap ei-analytics-2-conf-worker --from-file=../confs/ei-analytics-2/conf/worker

${KUBECTL} create configmap sp-dashboard-conf-dashboard --from-file=../confs/dashboard/conf/dashboard

${KUBECTL} create configmap mysql-dbscripts --from-file=../extras/confs/mysql/dbscripts/

echoBold 'Deploying the Kubernetes Services...'
${KUBECTL} create -f ../extras/rdbms/mysql/mysql-service.yaml
${KUBECTL} create -f ../analytics/integrator-analytics-1-service.yaml
${KUBECTL} create -f ../analytics/integrator-analytics-2-service.yaml
${KUBECTL} create -f ../analytics/integrator-analytics-service.yaml
${KUBECTL} create -f ../integrator/integrator-service.yaml
${KUBECTL} create -f ../integrator/integrator-gateway-service.yaml
${KUBECTL} create -f ../dashboard/integrator-server-dashboard-service.yaml

# MySQL
echoBold 'Deploying WSO2 Enterprise Integrator and Enterprise Integrator Analytics Databases using MySQL...'
${KUBECTL} create -f ../extras/rdbms/mysql/mysql-deployment.yaml
sleep 10s

# persistent storage
echoBold 'Creating persistent volume and volume claim...'
${KUBECTL} create -f ../integrator/integrator-volume-claims.yaml
${KUBECTL} create -f ../extras/rdbms/mysql/mysql-persistent-volume-claim.yaml
${KUBECTL} create -f ../volumes/persistent-volumes.yaml
${KUBECTL} create -f ../extras/rdbms/volumes/persistent-volumes.yaml
sleep 10s

# Integrator
echoBold 'Deploying WSO2 Integrator and Analytics...'
${KUBECTL} create -f ../analytics/integrator-analytics-1-deployment.yaml
${KUBECTL} create -f ../analytics/integrator-analytics-2-deployment.yaml
${KUBECTL} create -f ../dashboard/integrator-server-dashboard-deployment.yaml
sleep 4m

${KUBECTL} create -f ../integrator/integrator-deployment.yaml
sleep 30s

echoBold 'Deploying Ingresses...'
${KUBECTL} create -f ../ingresses/integrator-ingress.yaml
${KUBECTL} create -f ../ingresses/integrator-gateway-ingress.yaml
${KUBECTL} create -f ../ingresses/integrator-server-dashboard-ingress.yaml
sleep 30s

echoBold 'Finished'
echo 'To access the WSO2 Enterprise Integrator management console, try https://wso2ei-integrator/carbon in your browser.'
echo 'To access the WSO2 Enterprise Integrator Analytics management console, try https://wso2ei-analytics/carbon in your browser.'
