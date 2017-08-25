# kubernetes-EI 
*Kubernetes Artifacts for 
Container-based Deployment Patterns
of WSO2 Enterprise Integrator*


This initial version contains the deployment of a single integrator container instance 
running with one local [h2] registry database and one external [MySQL] user management database.
 
## Getting Started

>In the context of this document, `KUBERNETES_HOME` will refer to a local copy of 
[`wso2/kubernetes-ei`](https://github.com/wso2/kubernetes-ei/) artifacts and you have to have git, docker and 
Kubernetes client, kubectl installed in your local machine to execute following steps.

##### 1. Checkout WSO2 kubernetes-ei repository using `git clone` :
```
git clone https://github.com/wso2/kubernetes-ei.git
```

##### 2. Pull required Docker images from [`WSO2 Docker Repositories`](https://docker.wso2.com) using docker :
```
docker pull docker.wso2.com/wso2ei-kubernetes-pattern1-integrator:6.1.1
docker pull docker.wso2.com/wso2ei-kubernetes-pattern1-mysql:5.5
```
##### 3. Copy the Images to Kubernetes Nodes / Registry :
Copy the required Docker images over to the Kubernetes Nodes (ex: use `docker save` to create a tarball of the required image, 
`scp` the tarball to each node, and use `docker load` to reload the images from the copied tarballs on the nodes). 
Alternatively, if a private Docker registry is used, transfer the images there.

##### 4. Deploy Kubernetes Artifacts :
Change directory to `KUBERNETES_HOME/pattern-1` and run `deploy-kubernetes.sh` shell script on the terminal.
```
sh deploy-kubernetes.sh
```
>To un-deploy, be on the same directory and run `undeploy-kubernetes.sh` shell script on the terminal.

##### 5. Access Management Console :
To access the console, try navigating to `https://<node-ip>:<node-port>/carbon` in your favorite browser.

>**node-ip** here is the physical IP of any kubernetes node including the kubernetes master.<br>
**node-port** is any externally exposed kubernetes port connecting to 9443 servlet-https service port.
