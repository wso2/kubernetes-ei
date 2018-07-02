# Helm Charts for deployment of WSO2 Enterprise Integrator - Broker with Analytics

## Prerequisites
* In order to use WSO2 Kubernetes resources, you need an active WSO2 subscription. If you do not possess an active WSO2
subscription already, you can sign up for a WSO2 Free Trial Subscription from [here](https://wso2.com/free-trial-subscription).<br><br>

* Install [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git), [Helm](https://github.com/kubernetes/helm/blob/master/docs/install.md)
(and Tiller) and [Kubernetes client](https://kubernetes.io/docs/tasks/tools/install-kubectl/) in order to run the 
steps provided in the following quick start guide.<br><br>

* Install [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/deploy/). This can
 be easily done via 
  ```
  helm install stable/nginx-ingress --name nginx-wso2integrator-broker-with-analytics --set rbac.create=true
  ```
## Quick Start Guide
>In the context of this document, <br>
>* `KUBERNETES_HOME` will refer to a local copy of the [`wso2/kubernetes-ei`](https://github.com/wso2/kubernetes-ei/)
Git repository. <br>
>* `HELM_HOME` will refer to `<KUBERNETES_HOME>/helm/integrator-broker-with-analytics`. <br>

##### 1. Checkout Kubernetes Resources for WSO2 Enterprise Integrator Git repository:

```
git clone https://github.com/wso2/kubernetes-ei.git
```

##### 2. Provide configurations:

1. The default product configurations are available at `<HELM_HOME>/integrator-broker-with-analytics-conf/confs` folder. Change the 
configurations as necessary.

2. Open the `<HELM_HOME>/integrator-broker-with-analytics-conf/values.yaml` and provide the following values.

    `username`: Username of your WSO2 Subscription<br>
    `password`: Password of your WSO2 Subscription<br>
    `email`: Docker email<br>
    `namespace`: Namespace<br>
    `svcaccount`: Service Account<br>
    `serverIp`: NFS Server IP<br>
    `sharedDeploymentLocationPath`: NFS shared deployment directory(<EI_HOME>/repository/deployment) location for EI<br> 
    `sharedTenantsLocationPath`: NFS shared tenants directory(<EI_HOME>/repository/tenants) location for EI<br>
    `analytics1DataLocationPath`: NFS volume for Indexed data for Analytics node 1(<DAS_HOME>/repository/data)<br> 
    `analytics2DataLocationPath`: NFS volume for Indexed data for Analytics node 2(<DAS_HOME>/repository/data)<br> 
    `analytics1LocationPath`: NFS volume for Analytics data for Analytics node 1(<DAS_HOME>/repository/analytics)<br> 
    `analytics2LocationPath`: NFS volume for Analytics data for Analytics node 2(<DAS_HOME>/repository/analytics)
        
3. Open the `<HELM_HOME>/integrator-broker-with-analytics-deployment/values.yaml` and provide the following values.

    `namespace`: Namespace<br>
    `svcaccount`: Service Account
    
##### 3. Deploy the configurations:

```
helm install --name <RELEASE_NAME> <HELM_HOME>/integrator-broker-with-analytics-conf
```

##### 4. Deploy MySQL:
If there is an external product database(s), add those configurations as stated at `step 2.1`. Otherwise, run the below
 command to create the product database. 
```
helm install --name wso2ei-integrator-broker-with-analytics-rdbms-service -f <HELM_HOME>/mysql/values.yaml 
stable/mysql --namespace <NAMESPACE>
```
`NAMESPACE` should be same as `step 2.2`.

##### 5. Deploy WSO2 Enterprise Integrator with Analytics:

```
helm install --name <RELEASE_NAME> <HELM_HOME>/integrator-broker-with-analytics-deployment
```

##### 6. Access Management Console:

Default deployment will expose four publicly accessible hosts, namely:<br>
1. `wso2ei-integrator` - To expose Administrative services and Management Console<br>
2. `wso2ei-integrator-gateway` - To expose Mediation Gateway<br>
3. `wso2ei-analytics` - To expose Analytics<br>
3. `wso2ei-broker` - To expose Analytics<br>

To access the console in a test environment,

1. Obtain the external IP (`EXTERNAL-IP`) of the Ingress resources by listing down the Kubernetes Ingresses (using `kubectl get ing -n <NAMESPACE>`).

e.g.

```
NAME                                                         HOSTS                                ADDRESS          PORTS     AGE
wso2ei-analytics-ingress                                 wso2ei-analytics                        <EXTERNAL-IP>    80, 443   9m
wso2ei-integrator-gateway-tls-ingress              wso2ei-integrator-gateway                     <EXTERNAL-IP>    80, 443   9m
wso2ei-integrator-ingress                                wso2ei-integrator                       <EXTERNAL-IP>    80, 443   9m
wso2ei-mb-ingress                                           wso2ei-broker                        <EXTERNAL-IP>    80, 443   9m
```

2. Add the above Three hosts as entries in /etc/hosts file as follows:

```
<EXTERNAL-IP>	wso2ei-analytics
<EXTERNAL-IP>	wso2ei-integrator-gateway
<EXTERNAL-IP>	wso2ei-integrator
<EXTERNAL-IP>	wso2ei-broker
```

3. Try navigating to `https://wso2ei-integrator/carbon` from your favorite browser.
