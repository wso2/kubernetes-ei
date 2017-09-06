# WSO2 Enterprise Integrator Kubernetes Resources 
*Kubernetes Resources for container-based deployments of WSO2 Enterprise Integrator (EI)*

This initial version of kubernetes-ei contains the deployment of a "scalable" unit of WSO2 EI integrator profile, 
running on <br> top of `Kubernetes` with `Docker` and `MySQL` support.
 
## Quick Start Guide

>In the context of this document, `KUBERNETES_HOME` will refer to a local copy of 
[`wso2/kubernetes-ei`](https://github.com/wso2/kubernetes-ei/) git repository and you have to have git, docker and 
Kubernetes client, kubectl installed in your local machine to execute following steps.

##### 1. Checkout WSO2 kubernetes-ei repository using `git clone`:
```
git clone https://github.com/wso2/kubernetes-ei.git
```

##### 2. Pull required Docker images from [`WSO2 Docker Registry`](https://docker.wso2.com) using `docker pull`:
```
docker login docker.wso2.com
docker pull docker.wso2.com/wso2ei-kubernetes-integrator:6.1.1
docker pull docker.wso2.com/wso2ei-kubernetes-mysql:5.7
```
##### 3. Copy the Image in to Kubernetes Nodes or Registry:
Copy the required Docker images over to the Kubernetes Nodes (ex: use `docker save` to create a tarfile of the 
required image, `scp` the tarfile to each node, and use `docker load` to load the image from the copied tarfile 
on the nodes). Alternatively, if a private Docker registry is used, transfer the images there.

##### 4. Deploy Kubernetes Resources:
Change directory to `KUBERNETES_HOME/pattern-1` and run `deploy.sh` shell script on the terminal.
```
sh deploy.sh
```
>To un-deploy, be on the same directory and run `undeploy.sh` shell script on the terminal.

##### 5. Access Management Console:
To access the console, try navigating to `https://wso2ei-pattern1-integrator/carbon` from your favorite browser.

##### 6. How to scale using `kubectl scale`:
Default deployment runs only one replica (or pod) of WSO2 EI integrator profile. To scale this deployment into <br>
any `<n>` number of container replicas, necessary to suite your requirement, simply run following kubectl 
command on the terminal. Assuming your current working directory is `KUBERNETES_HOME/pattern-1` 
```
kubectl scale --replicas=<n> -f integrator-deployment.yaml
```
For example, If `<n>` is 3, you are here scaling up this deployment from 1 to 3 container replicas.
