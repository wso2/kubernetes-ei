# kubernetes-EI 
Kubernetes Artifacts for 
Container-based Deployment Patterns
of WSO2 Enterprise Integrator

This initial version (V0.1) contains the deployment of a single integrator container instance 
running with one [h2] local registry + external [MySQL] user management database.
 
## Getting Started

>You have to have git, docker and Kubernetes client, kubectl installed in your local machine to execute following steps.

##### 1. Checkout WSO2 kubernetes-ei repository using `git clone`
```
git clone https://github.com/wso2/kubernetes-ei.git
```

##### 2. Pull required Docker images from [`WSO2 Docker Repositories`](https://docker.wso2.com) using docker.
```
docker pull docker.wso2.com/wso2ei-kubernetes-pattern1-integrator:6.1.1
docker pull docker.wso2.com/wso2ei-kubernetes-pattern1-mysql:5.5
```
##### 3. Copy the Images to Kubernetes Nodes / Registry
Copy the required Docker images over to the Kubernetes Nodes (ex: use `docker save` to create a tarball of the required image, `scp` the tarball to each node, and use `docker load` to reload the images from the copied tarballs on the nodes). Alternatively, if a private Docker registry is used, transfer the images there.

##### 4. Deploy Kubernetes Artifacts
To deploy artifacts, run `deploy-kubernetes.sh` shell script on terminal.
```
./deploy-kubernetes.sh
```

##### 5. Access Management Console
To access the console, try https://<node-ip>:<node-port>/carbon in your favorite browser.

##### 6. Un-deploy Kubernetes Artifacts
To un-deploy artifacts, run `undeploy-kubernetes.sh` shell script on the terminal.
```
./deploy-kubernetes.sh
```