# Kubernetes Test Resources for deployment of Integrator profile of WSO2 Enterprise Integrator

Kubernetes Test Resources for WSO2 Enterprise Integrator contains artifacts, which can be used to test the core<br>
Kubernetes resources provided for deployment of a "scalable" unit of WSO2 Enterprise Integrator's Integrator profile.

## Prerequisites

* In order to use these Kubernetes resources, you will need an active [Free Trial Subscription](https://wso2.com/free-trial-subscription)
from WSO2 since the referring Docker images hosted at docker.wso2.com contains the latest updates and fixes for WSO2 Enterprise Integrator.
You can sign up for a Free Trial Subscription [here](https://wso2.com/free-trial-subscription).<br><br>

* Install [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git), [Docker](https://www.docker.com/get-docker)
(version 17.09.0 or above) and [Kubernetes client](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
in order to run the steps provided<br>in the following quick start guide.<br><br>

* An already setup [Kubernetes cluster](https://kubernetes.io/docs/setup/pick-right-solution/)<br><br>
 
## Quick Start Guide

>In the context of this document, `KUBERNETES_HOME` will refer to a local copy of the [`wso2/kubernetes-ei`](https://github.com/wso2/kubernetes-ei/)
Git repository.<br>

##### 1. Checkout Kubernetes Resources for WSO2 Enterprise Integrator Git repository:

```
git clone https://github.com/wso2/kubernetes-ei.git
```

##### 2. Update the deploy.sh file with the [`WSO2 Docker Registry`](https://docker.wso2.com) credentials and Kubernetes cluster admin password.

Replace the relevant placeholders in `KUBERNETES_HOME/scalable-integrator/test/deploy.sh` file with appropriate details, as described below.

* A Kubernetes Secret named `wso2creds` in the cluster to authenticate with the WSO2 Docker Registry, to pull the required images.
The following details need to be replaced in the relevant command.

```
kubectl create secret docker-registry wso2creds --docker-server=docker.wso2.com --docker-username=<username> --docker-password=<password> --docker-email=<email>
```

`username`: Username of your Free Trial Subscription<br>
`password`: Password of your Free Trial Subscription<br>
`email`: Docker email

* A Kubernetes role and a role binding necessary for the Kubernetes API requests made from Kubernetes membership scheme.

`cluster-admin-password`: Kubernetes cluster admin password

##### 3. Deploy Kubernetes test resources:

Change directory to `KUBERNETES_HOME/scalable-integrator/test` and execute the `deploy.sh` shell script on the terminal.

```
./deploy.sh
```
>To un-deploy, be on the same directory and execute the `undeploy.sh` shell script on the terminal.

##### 4. Access Management Console:

Obtain the `EXTERNAL-IP` for `wso2ei-pattern1-integrator-service` service (use `kubectl get svc`).

```
NAME                                 CLUSTER-IP     EXTERNAL-IP    PORT(S)    AGE
wso2ei-pattern1-integrator-service   ..........    <EXTERNAL-IP>   ......     ....
```

Try navigating to the management console using `https://<EXTERNAL-IP>:9443/carbon` from your favorite browser.
