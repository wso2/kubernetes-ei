# Kubernetes Test Resources for deployment of Integrator profile of WSO2 Enterprise Integrator
*Kubernetes Test Resources for container-based deployments of WSO2 Enterprise Integrator*

Kubernetes Test Resources for WSO2 Enterprise Integrator contains artifacts, which can be used to test the core<br>
Kubernetes resources provided for deployment of a "scalable" unit of WSO2 Enterprise Integrator's Integrator profile.

## Prerequisites

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

##### 2. Build the Docker images using the [`Docker resources`](../../dockerfiles) provided in this repository.

##### 3. Copy the Docker images into the Kubernetes Nodes or Registry:

Copy the required Docker images over to the Kubernetes Nodes (e.g. use `docker save` to create a tarfile of the 
required image, `scp` the tarfile to each node and use `docker load` to load the image from the copied tarfile 
within the nodes).

Alternatively, if a private Docker registry is used, transfer the images there.

##### 4. Deploy Kubernetes test resources:

Change directory to `KUBERNETES_HOME/pattern-1/test` and execute the `deploy.sh` shell script on the terminal.

```
./deploy.sh
```
>To un-deploy, be on the same directory and execute the `undeploy.sh` shell script on the terminal.

##### 5. Access Management Console:

Default deployment will expose two publicly accessible hosts, namely: <br>
1. `wso2ei-pattern1-integrator` - To expose Administrative services and Management Console <br>
2. `wso2ei-pattern1-integrator-gateway` - To expose Mediation Gateway <br>

To access the console in a test environment, add the above two hosts as entries in /etc/hosts file, pointing to one of<br>
your Kubernetes cluster node IPs and try navigating to `https://wso2ei-pattern1-integrator/carbon` from your favorite browser.
