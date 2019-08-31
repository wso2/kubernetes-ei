# Kubernetes and Helm Resources for WSO2 Enterprise Integrator
*Kubernetes and Helm Resources for container-based deployments of WSO2 Enterprise Integrator deployment patterns*

This repository contains Kubernetes and Helm resources required for,

* A clustered deployment of WSO2 Enterprise Integrator's Integrator profile with Integrator Analytics support

* Clustered deployments of WSO2 Enterprise Integrator's Integrator and Broker profile with Integrator Analytics support

## Deploy Kubernetes resources

In order to deploy Kubernetes resources for each deployment pattern, follow the **Quick Start Guide**s for each deployment pattern
given below:

### Simple

* [A Simplified setup for WSO2 Enterprise Integrator](simple/single-script/README.md)

### Advanced

**Note**: We consider Helm to be the primary source of installation of WSO2 product deployment patterns in Kubernetes environments. Hence, pure Kubernetes resources for product deployment patterns will be deprecated from 6.5.0.3 onwards. Please adjust your usage accordingly.

* [A clustered deployment of WSO2 Enterprise Integrator's Integrator profile with Integrator Analytics support](advanced/integrator-analytics/README.md)

* [Clustered deployments of WSO2 Enterprise Integrator's Integrator and Broker profile with Integrator Analytics support](advanced/integrator-broker-analytics/README.md)

## Deploy Helm resources

In order to deploy Helm resources for each deployment pattern, follow the **Quick Start Guide**s for each deployment pattern
given below:

* [A clustered deployment of WSO2 Enterprise Integrator's Integrator profile with Integrator Analytics support](advanced/helm/integrator-with-analytics/README.md)

* [Clustered deployments of WSO2 Enterprise Integrator's Integrator and Broker profile with Integrator Analytics support](advanced/helm/integrator-broker-with-analytics/README.md)

## Changelog

**Change log** from previous v6.5.0.2 release: [View Here](CHANGELOG.md)

## Reporting issues

We encourage you to report any issues and documentation faults regarding Kubernetes and Helm resources
for WSO2 Integration. Please report your issues [here](https://github.com/wso2/kubernetes-ei/issues).
