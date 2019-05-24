# Kubernetes Test Resources for deployment of Integrator and Broker profiles of WSO2 Enterprise Integrator with Analytics

Kubernetes Test Resources for deployment of Integrator and Broker profiles of WSO2 Enterprise Integrator with Analytics
contain artifacts, which can be used to test the core Kubernetes resources provided for a clustered deployment
of WSO2 Enterprise Integrator's Integrator and Broker profiles with Analytics support.

## Contents

* [Prerequisites](#prerequisites)
* [Quick Start Guide](#quick-start-guide)

## Prerequisites

* In order to use updated docker images, you need an active WSO2 subscription. If you do not possess an active WSO2
  subscription already, you can sign up for a WSO2 Free Trial Subscription from [here](https://wso2.com/free-trial-subscription)
  . Otherwise you can proceed with docker images which are created using GA releases.<br><br>

* Install [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Kubernetes client](https://kubernetes.io/docs/tasks/tools/install-kubectl/) (compatible with v1.10)
in order to run the steps provided in the following quick start guide.<br><br>

* An already setup [Kubernetes cluster](https://kubernetes.io/docs/setup/pick-right-solution/).<br><br>

* A pre-configured Network File System (NFS) to be used as the persistent volume for artifact sharing and persistence.
In the NFS server instance, create a Linux system user account named `wso2carbon` with user id `802` and a system group named `wso2` with group id `802`.
Add the `wso2carbon` user to the group `wso2`.

```
groupadd --system -g 802 wso2
useradd --system -g 802 -u 802 wso2carbon
```

## Quick Start Guide

>In the context of this document, `KUBERNETES_HOME` will refer to a local copy of the [`wso2/kubernetes-ei`](https://github.com/wso2/kubernetes-ei/)
Git repository.<br>

##### 1. Clone the Kubernetes Resources for WSO2 Enterprise Integrator Git repository.

```
git clone https://github.com/wso2/kubernetes-ei.git
```

##### 2. Deploy Kubernetes Ingress resource.

The WSO2 Enterprise Integrator Kubernetes Ingress resource uses the NGINX Ingress Controller.

In order to enable the NGINX Ingress controller in the desired cloud or on-premise environment,
please refer the official documentation, [NGINX Ingress Controller Installation Guide](https://kubernetes.github.io/ingress-nginx/deploy/).

##### 3. Setup a Network File System (NFS) to be used for persistent storage.

Create and export unique directories within the NFS server instance for each Kubernetes Persistent Volume resource defined in the
`<KUBERNETES_HOME>/advanced/integrator-broker-analytics/volumes/persistent-volumes.yaml` file.

Grant ownership to `wso2carbon` user and `wso2` group, for each of the previously created directories.

```
sudo chown -R wso2carbon:wso2 <directory_name>
```

Grant read-write-execute permissions to the `wso2carbon` user, for each of the previously created directories.

```
chmod -R 700 <directory_name>
```

Update each Kubernetes Persistent Volume resource with the corresponding NFS server IP (`NFS_SERVER_IP`) and exported, NFS server directory path (`NFS_LOCATION_PATH`).``

##### 4. Setup product database(s).

For **evaluation purposes**,

* You can use Kubernetes resources provided in the directory `KUBERNETES_HOME/integrator-broker-analytics/extras/rdbms/mysql`
for deploying the product databases, using MySQL in Kubernetes. However, this approach of product database deployment is
**not recommended** for a production setup.

* For using these Kubernetes resources,

  Here, a Network File System (NFS) is needed to be used for persisting MySQL DB data.    
  
  Create and export a directory within the NFS server instance.
        
  Provide read-write-execute permissions to other users for the created folder.
        
  Update the Kubernetes Persistent Volume resource with the corresponding NFS server IP (`NFS_SERVER_IP`) and exported,
  NFS server directory path (`NFS_LOCATION_PATH`) in `<KUBERNETES_HOME>/advanced/integrator-broker-analytics/extras/rdbms/volumes/persistent-volumes.yaml`.
  
In a **production grade setup**,

* Setup the external product databases. Please refer to WSO2's official documentation [1](https://docs.wso2.com/display/EI640/Clustering+the+ESB+Profile#ClusteringtheESBProfile-Creatingthedatabases),
  [2](https://docs.wso2.com/display/EI640/Clustering+the+Message+Broker+Profile#ClusteringtheMessageBrokerProfile-Creatingthedatabases) and
  [3](https://docs.wso2.com/display/EI640/Minimum+High+Availability+Deployment) on creating the required databases for the deployment.
  
  Provide appropriate connection URLs, corresponding to the created external databases and the relevant driver class names for the data sources defined in
  the following files:
  
  * `<KUBERNETES_HOME>/advanced/integrator-broker-analytics/confs/broker/datasources/master-datasources.xml`
  * `<KUBERNETES_HOME>/advanced/integrator-broker-analytics/confs/ei-analytics/conf/worker/deployment.yaml`
  * `<KUBERNETES_HOME>/advanced/integrator-broker-analytics/confs/ei-analytics-dashboard/conf/worker/deployment.yaml`
  * `<KUBERNETES_HOME>/advanced/integrator-broker-analytics/confs/integrator/datasources/master-datasources.xml`
  
  Please refer WSO2's [official documentation](https://docs.wso2.com/display/ADMIN44x/Configuring+master-datasources.xml) on configuring data sources.

##### 5. Deploy Kubernetes resources.

Change directory to `<KUBERNETES_HOME>/advanced/integrator-broker-analytics/scripts` and execute the `deploy.sh` shell script on the terminal as follows:

```
./deploy.sh 
```

* A Kubernetes role and a role binding necessary for the Kubernetes API requests made from Kubernetes membership scheme. In order to create these resource an user with Kubernetes cluster-admin role is required.

>To un-deploy, be on the same directory and execute the `undeploy.sh` shell script on the terminal.

##### 6. Access Management Consoles.

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

##### 7. Scale up using `kubectl scale`.

Default deployment runs a single replica (or pod) of WSO2 Enterprise Integrator's Integrator profile. To scale this deployment into any `<n>` number of
container replicas, upon your requirement, simply run following Kubernetes client command on the terminal.

```
kubectl scale --replicas=<n> -f <KUBERNETES_HOME>/advanced/integrator-broker-analytics/integrator/integrator-deployment.yaml
```

For example, If `<n>` is 2, you are here scaling up this deployment from 1 to 2 container replicas.
