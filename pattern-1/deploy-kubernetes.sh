#!/usr/bin/env bash

# params
artifacts=./artifacts

# rdbms
echo '[1] Deploying external databases ...'
kubectl create -f ${artifacts}/rdbms-service.yaml
kubectl create -f ${artifacts}/rdbms-deployment.yaml
sleep 60s

# integrator
echo '[2] Deploying integrator ...'
kubectl create -f ${artifacts}/integrator-service.yaml
kubectl create -f ${artifacts}/integrator-deployment.yaml
sleep 60s

echo 'Finished ...'
echo 'To access the console, try https://<node-ip>:<node-port>/carbon in your favorite browser ...'