# kubernetes-EI 
Kubernetes Artifacts for 
Container-based Deployment Patterns
of WSO2 Enterprise Integrator

This initial version (V0.1) contains the deployment of 
a single integrator container instance connected to an external mysql database.
 
## Getting Started

>You have to have Docker and Kubernetes client, kubectl installed in your local machine to execute following steps.

##### 1. Pull required Docker images from [`WSO2 Docker Repositories`](https://docker.wso2.com) using Docker.
```
docker pull docker.wso2.com/wso2ei-kubernetes-pattern1-integrator:6.1.1
docker pull docker.wso2.com/wso2ei-kubernetes-pattern1-mysql:5.5
```
##### 2. Copy the Images to Kubernetes Nodes / Registry
Copy the required Docker images over to the Kubernetes Nodes (ex: use `docker save` to create a tarball of the required image, `scp` the tarball to each node, and use `docker load` to reload the images from the copied tarballs on the nodes). Alternatively, if a private Docker registry is used, transfer the images there.

##### 3. Deploy Kubernetes Artifacts
