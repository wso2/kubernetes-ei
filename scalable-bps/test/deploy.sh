#!/usr/bin/env bash

# ------------------------------------------------------------------------
# Copyright 2018 WSO2, Inc. (http://wso2.com)
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
set -e

function echoBold () {
    echo $'\e[1m'"${1}"$'\e[0m'
}

# create a new Kubernetes Namespace
kubectl create namespace wso2

# create a new service account in 'wso2' Kubernetes Namespace
kubectl create serviceaccount wso2svc-account -n wso2

# switch the context to new 'wso2' namespace
kubectl config set-context $(kubectl config current-context) --namespace=wso2

kubectl create secret docker-registry wso2creds --docker-server=docker.wso2.com --docker-username=<username> --docker-password=<password> --docker-email=<email>

# create Kubernetes role and role binding necessary for the Kubernetes API requests made from Kubernetes membership scheme
kubectl create --username=admin --password=<cluster-admin-password> -f ../../rbac/rbac.yaml

# configuration maps
echoBold 'Creating Configuration Maps...'
kubectl create configmap bps-conf --from-file=../confs
kubectl create configmap bps-conf-axis2 --from-file=../confs/axis2/
kubectl create configmap bps-conf-datasources --from-file=../confs/datasources/
kubectl create configmap bps-conf-etc --from-file=../confs/etc/
kubectl create configmap mysql-dbscripts --from-file=confs/mysql/dbscripts/

# MySQL
echoBold 'Deploying WSO2 Integrator Databases...'
kubectl create -f rdbms/mysql/mysql-service.yaml
kubectl create -f rdbms/mysql/mysql-deployment.yaml
sleep 10s

# persistent storage
echoBold 'Creating persistent volume and volume claim...'
kubectl create -f ../bps-volume-claim.yaml
kubectl create -f ../volumes/persistent-volumes.yaml

# integrator
echoBold 'Deploying WSO2 Integrator...'
kubectl create -f ../bps-service.yaml
kubectl create -f ../bps-deployment.yaml
sleep 60s

echoBold 'Finished'
echo 'To access the console, try https://wso2ei-pattern1-integrator/carbon in your browser.'
