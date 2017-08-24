#!/usr/bin/env bash

# rdbms
echo '[1] deploying external databases ...'
kubectl create -f rdbms-service.yaml
kubectl create -f rdbms-deployment.yaml
sleep 60s

# integrator
echo '[2] deploying integrator ...'
kubectl create -f integrator-service.yaml
kubectl create -f integrator-deployment.yaml
sleep 60s

echo 'finished ...'
echo 'To access the console, try https://<node-ip>:<node-port>/carbon in your favorite browser ...'