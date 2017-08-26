#!/usr/bin/env bash

# Integrator
echo 'Un-deploying WSO2 Integrator...'
kubectl delete deployment wso2ei-pattern1-integrator-deployment
kubectl delete service wso2ei-pattern1-integrator-service

# Databases
echo 'Un-deploying WSO2 Integrator Databases...'
kubectl delete deployment wso2ei-pattern1-mysql-deployment
kubectl delete service wso2ei-pattern1-mysql-service

echo 'Finished'