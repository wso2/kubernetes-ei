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

set -e

# NGINX INGRESS Controller
echo 'Un-deploying NGINX INGRESS Controller...'
kubectl delete deployment nginx-default-http-backend
kubectl delete deployment nginx-ingress-controller
kubectl delete ingress wso2ei-pattern1-integrator-ingress

# Integrator
echo 'Un-deploying WSO2 Integrator...'
kubectl delete deployment wso2ei-pattern1-integrator-deployment
kubectl delete service wso2ei-pattern1-integrator-gateway-service
kubectl delete service wso2ei-pattern1-integrator-service

# Databases
echo 'Un-deploying WSO2 Integrator Databases...'
kubectl delete deployment wso2ei-pattern1-mysql-deployment
kubectl delete service wso2ei-pattern1-mysql-service

echo 'Finished'