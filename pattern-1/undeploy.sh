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

# NGINX INGRESS Controller
echoBold 'Un-deploying NGINX INGRESS Controller...'
kubectl delete -f integrator-ingress.yaml
kubectl delete -f nginx-ingress-controller.yaml
kubectl delete -f nginx-default-backend.yaml

# Integrator
echoBold 'Un-deploying WSO2 Integrator...'
kubectl delete -f integrator-deployment.yaml
kubectl delete -f integrator-gateway-service.yaml
kubectl delete -f integrator-service.yaml

# Databases
echoBold 'Un-deploying WSO2 Integrator Databases...'
kubectl delete -f mysql-deployment.yaml
kubectl delete -f mysql-service.yaml

echoBold 'Finished'
