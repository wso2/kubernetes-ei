#!/usr/bin/env bash

# integrator
echo '[1] un-deploying integrator ...'
kubectl delete deployment wso2ei-pattern1-integrator-deployment
kubectl delete service wso2ei-pattern1-integrator-service
sleep 60s

# rdbms
echo '[2] un-deploying external databases ...'
kubectl delete deployment wso2ei-pattern1-mysql-deployment
kubectl delete service wso2ei-pattern1-mysql-service
sleep 60s

echo 'finished ...'