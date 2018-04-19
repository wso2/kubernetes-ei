# Dockerfiles for WSO2 Enterprise Integrator #
This section defines dockerfiles and step-by-step instructions to build docker images for multiple profiles <br>
provided by WSO2 Enterprise Integrator 6.2.0, namely : <br>
1. Integrator
2. Analytics

## Prerequisites
* [Docker](https://www.docker.com/get-docker) v17.09.0 or above

## How to build an image and run
##### 1. Checkout this repository into your local machine using the following git command.
```
git clone https://github.com/wso2/kubernetes-ei.git
```

>The local copy of the `dockerfiles` directory will be referred to as `DOCKERFILE_HOME` from this point onwards.

##### 2. Add JDK, WSO2 Enterprise Integrator distribution and required libraries
- Download [JDK 1.8](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) and
extract into `<DOCKERFILE_HOME>/base/files`.
- Download [WSO2 Enterprise Integrator 6.2.0 distribution](https://wso2.com/integration) and 
extract into `<DOCKERFILE_HOME>/base/files`.
- Once both JDK and WSO2 Enterprise Integrator distribution is extracted, it should be as follows:
```
<DOCKERFILE_HOME>/base/files/jdk<version>
<DOCKERFILE_HOME>/base/files/wso2ei-6.2.0
```
- Download [MySQL Connector/J](https://dev.mysql.com/downloads/connector/j/) v5.1.45 and then copy that to `<DOCKERFILE_HOME>/base/files` folder.
>Please refer to [WSO2 Update Manager documentation](https://docs.wso2.com/display/ADMIN44x/Updating+WSO2+Products)
in order to obtain latest bug fixes and updates for the product.

##### 3. Build the base docker image.
- For base, navigate to `<DOCKERFILE_HOME>/base` directory. <br>
  Execute `docker build` command as shown below.
    + `docker build -t wso2ei-base:6.2.0 .`
        
##### 4. Build docker images specific to each profile.
- For integrator, navigate to `<DOCKERFILE_HOME>/integrator` directory. <br>
  Execute `docker build` command as shown below. 
    + `docker build -t wso2ei-integrator:6.2.0 .`
- For analytics, navigate to `<DOCKERFILE_HOME>/analytics` directory. <br>
  Execute `docker build` command as shown below. 
    + `docker build -t wso2ei-analytics:6.2.0 .`
    
##### 5. Running docker images specific to each profile.
- For integrator,
    + `docker run -p 8280:8280 -p 8243:8243 -p 9443:9443 wso2ei-integrator:6.2.0`
- For analytics,
    + `docker run -p 9444:9444 -p 9612:9612 -p 9712:9712 wso2ei-analytics:6.2.0`

##### 6. Accessing management console per each profile.
- For integrator,
    + `https:<DOCKER_HOST>:9443/carbon`
- For analytics,
    + `https:<DOCKER_HOST>:9444/carbon`
    
>In here, <DOCKER_HOST> refers to hostname or IP of the host machine on top of which containers are spawned.

## Docker command usage references

* [Docker build command reference](https://docs.docker.com/engine/reference/commandline/build/)
* [Docker run command reference](https://docs.docker.com/engine/reference/run/)
* [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
