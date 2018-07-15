# Helm Chart for a deployment of Integrator and Broker profiles of WSO2 Enterprise Integrator with Analytics

## Contents

* [Prerequisites](#prerequisites)
* [Quick Start Guide](#quick-start-guide)

## Prerequisites

* In order to use WSO2 Helm resources, you need an active WSO2 subscription. If you do not possess an active WSO2
  subscription already, you can sign up for a WSO2 Free Trial Subscription from [here](https://wso2.com/free-trial-subscription).<br><br>

* Install [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git), [Helm](https://github.com/kubernetes/helm/blob/master/docs/install.md)
(and Tiller) and [Kubernetes client](https://kubernetes.io/docs/tasks/tools/install-kubectl/) (compatible with v1.10) in order to run the 
steps provided in the following quick start guide.<br><br>

* An already setup [Kubernetes cluster](https://kubernetes.io/docs/setup/pick-right-solution/).<br><br>

* Install [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/deploy/). This can be easily done via 
  ```
  helm install stable/nginx-ingress --name nginx-wso2integrator-with-analytics --set rbac.create=true
  ```

## Quick Start Guide
>In the context of this document, <br>
>* `KUBERNETES_HOME` will refer to a local copy of the [`wso2/kubernetes-ei`](https://github.com/wso2/kubernetes-ei/)
Git repository. <br>
>* `HELM_HOME` will refer to `<KUBERNETES_HOME>/helm/integrator-broker-with-analytics`. <br>

##### 1. Clone Kubernetes Resources for WSO2 Enterprise Integrator Git repository.

```
git clone https://github.com/wso2/kubernetes-ei.git
```

##### 2. Setup a Network File System (NFS) to be used for persistent storage.

Create and export unique directories within the NFS server instance for each of the following Kubernetes Persistent Volume
resources defined in the `<HELM_HOME>/integrator-broker-with-analytics-conf/values.yaml` file:

* `sharedDeploymentLocationPath`
* `sharedTenantsLocationPath`
* `analytics1DataLocationPath`
* `analytics2DataLocationPath`
* `analytics1LocationPath`
* `analytics2LocationPath`

Grant ownership to `wso2carbon` user and `wso2` group, for each of the previously created directories.

  ```
  sudo chown -R wso2carbon:wso2 <directory_name>
  ```

Grant read-write-execute permissions to the `wso2carbon` user, for each of the previously created directories.

  ```
  chmod -R 700 <directory_name>
  ```

##### 3. Provide configurations.

a. The default product configurations are available at `<HELM_HOME>/integrator-broker-with-analytics-conf/confs` folder. Change the 
configurations as necessary.

b. Open the `<HELM_HOME>/integrator-broker-with-analytics-conf/values.yaml` and provide the following values.

| Parameter                       | Description                                                                               |
|---------------------------------|-------------------------------------------------------------------------------------------|
| `username`                      | Your WSO2 username                                                                        |
| `password`                      | Your WSO2 password                                                                        |
| `email`                         | Docker email                                                                              |
| `namespace`                     | Kubernetes Namespace in which the resources are deployed                                  |
| `svcaccount`                    | Kubernetes Service Account in the `namespace` to which product instance pods are attached |
| `serverIp`                      | NFS Server IP                                                                             |
| `sharedDeploymentLocationPath`  | NFS shared deployment directory(`<EI_HOME>/repository/deployment`) location for EI        |
| `sharedTenantsLocationPath`     | NFS shared tenants directory(`<EI_HOME>/repository/tenants`) location for EI              |
| `analytics1DataLocationPath`    | NFS volume for Indexed data for Analytics node 1(`<DAS_HOME>/repository/data`)            |
| `analytics2DataLocationPath`    | NFS volume for Indexed data for Analytics node 2(`<DAS_HOME>/repository/data`)            |
| `analytics1LocationPath`        | NFS volume for Analytics data for Analytics node 1(`<DAS_HOME>/repository/analytics`)     |
| `analytics2LocationPath`        | NFS volume for Analytics data for Analytics node 2(`<DAS_HOME>/repository/analytics`)     |

c. Open the `<HELM_HOME>/integrator-broker-with-analytics-deployment/values.yaml` and provide the following values. 
    
| Parameter                       | Description                                                                               |
|---------------------------------|-------------------------------------------------------------------------------------------|
| `namespace`                     | Kubernetes Namespace in which the resources are deployed                                  |
| `svcaccount`                    | Kubernetes Service Account in the `namespace` to which product instance pods are attached |

##### 4. Deploy the configurations.

```
helm install --name <RELEASE_NAME> <HELM_HOME>/integrator-broker-with-analytics-conf
```

##### 5. Deploy product database(s) using MySQL in Kubernetes.

```
helm install --name wso2ei-integrator-broker-with-analytics-rdbms-service -f <HELM_HOME>/mysql/values.yaml stable/mysql --namespace <NAMESPACE>
```

`NAMESPACE` should be same as in `step 3.b`.

For a serious deployment (e.g. production grade setup), it is recommended to connect product instances to a user owned and managed RDBMS instance.

##### 6. Deploy WSO2 Enterprise Integrator and Broker with Analytics.

```
helm install --name <RELEASE_NAME> <HELM_HOME>/integrator-broker-with-analytics-deployment
```

##### 7. Access product management consoles.

Default deployment will expose `wso2ei-integrator`, `wso2ei-broker`, `wso2ei-integrator-gateway` and `wso2ei-analytics` hosts.

To access the console in the environment,

a. Obtain the external IP (`EXTERNAL-IP`) of the Ingress resources by listing down the Kubernetes Ingresses.

```
kubectl get ing
```
e.g.

```
NAME                                        HOSTS                       ADDRESS        PORTS     AGE
wso2ei-analytics-ingress                    wso2ei-analytics            <EXTERNAL-IP>  80, 443   2m
wso2ei-integrator-gateway-tls-ingress       wso2ei-integrator-gateway   <EXTERNAL-IP>  80, 443   2m
wso2ei-integrator-ingress                   wso2ei-integrator           <EXTERNAL-IP>  80, 443   2m
wso2ei-mb-ingress                           wso2ei-broker               <EXTERNAL-IP>  80, 443   2m
```

b. Add the above host as an entry in /etc/hosts file as follows:

```
<EXTERNAL-IP>	wso2ei-analytics
<EXTERNAL-IP>	wso2ei-integrator-gateway
<EXTERNAL-IP>	wso2ei-integrator
<EXTERNAL-IP>	wso2ei-broker
```

c. Try navigating to `https://wso2ei-integrator/carbon`, `https://wso2ei-broker/carbon` and `https://wso2ei-analytics/carbon` from your favorite browser.
