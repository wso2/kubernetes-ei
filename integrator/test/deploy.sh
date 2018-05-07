#!/usr/bin/env bash

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

# methods
function echoBold () {
    echo $'\e[1m'"${1}"$'\e[0m'
}

set -e

# create a new Kubernetes Namespace
kubectl create namespace wso2

# create a new service account in 'wso2' Kubernetes Namespace
kubectl create serviceaccount wso2svc-account -n wso2

# switch the context to new 'wso2' namespace
kubectl config set-context $(kubectl config current-context) --namespace=wso2

kubectl create --username=admin --password=<cluster-admin-password> -f ../rbac/rbac.yaml

# configuration maps
echoBold 'Creating Configuration Maps...'
kubectl create configmap integrator-conf --from-file=../conf/integrator/conf/
kubectl create configmap integrator-conf-axis2 --from-file=../conf/integrator/conf/axis2/
kubectl create configmap integrator-conf-datasources --from-file=../conf/integrator/conf/datasources/
kubectl create configmap mysql-conf --from-file=conf/mysql/conf/
kubectl create configmap mysql-dbscripts --from-file=conf/mysql/dbscripts/

# mysql
echoBold 'Deploying WSO2 Integrator Databases...'
kubectl create -f rdbms/mysql/mysql-service.yaml
kubectl create -f rdbms/mysql/mysql-deployment.yaml
sleep 10s

# integrator
echoBold 'Deploying WSO2 Integrator...'
kubectl create -f ../integrator/integrator-service.yaml
kubectl create -f ../integrator/integrator-gateway-service.yaml
kubectl create -f ../integrator/integrator-deployment.yaml
sleep 60s

# deploying the ingress resource
echoBold 'Deploying Ingress...'
kubectl create -f ../ingresses/integrator-ingress.yaml
sleep 20s

echoBold 'Finished'
echo 'To access the console, try https://wso2ei-pattern1-integrator/carbon in your browser.'
