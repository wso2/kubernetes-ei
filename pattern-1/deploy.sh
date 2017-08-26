#!/usr/bin/env bash

# mysql
echo 'Deploying WSO2 Integrator Databases...'
kubectl create -f rdbms-service.yaml
kubectl create -f rdbms-deployment.yaml
sleep 60s

# integrator
echo 'Deploying WSO2 Integrator...'
kubectl create -f integrator-service.yaml
kubectl create -f integrator-deployment.yaml
sleep 60s

echo 'Finished'
echo 'To access the console, try https://<node-ip>:<node-port>/carbon in your browser.