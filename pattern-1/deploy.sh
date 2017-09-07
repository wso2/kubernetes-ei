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

# configuration maps
echoBold 'Creating Configuration Maps...'
kubectl create configmap integrator-conf --from-file=conf/integrator/conf/
kubectl create configmap integrator-conf-axis2 --from-file=conf/integrator/conf/axis2/
kubectl create configmap integrator-conf-datasources --from-file=conf/integrator/conf/datasources/

# mysql
echoBold 'Deploying WSO2 Integrator Databases...'
kubectl create -f mysql-service.yaml
kubectl create -f mysql-deployment.yaml
sleep 10s

# integrator
echoBold 'Deploying WSO2 Integrator...'
kubectl create -f integrator-service.yaml
kubectl create -f integrator-gateway-service.yaml
kubectl create -f integrator-deployment.yaml
sleep 60s

# nginx ingress controller
echoBold 'Deploying NGINX Ingress Controller...'
kubectl create -f nginx-default-backend.yaml
kubectl create -f nginx-ingress-controller.yaml
kubectl create -f integrator-ingress.yaml
sleep 20s

echoBold 'Finished'
echo 'To access the console, try https://wso2ei-pattern1-integrator/carbon in your browser.'
