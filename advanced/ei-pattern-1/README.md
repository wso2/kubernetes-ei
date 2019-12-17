# Helm Chart for deployment of Integrator profile of WSO2 Enterprise Integrator with Analytics

## Contents

* [Prerequisites](#prerequisites)
* [Quick Start Guide](#quick-start-guide)

## Prerequisites

* In order to use WSO2 Helm resources, you need an active WSO2 subscription. If you do not possess an active WSO2
  subscription already, you can sign up for a WSO2 Free Trial Subscription from [here](https://wso2.com/free-trial-subscription)
  . Otherwise you can proceed with docker images which are created using GA releases.<br><br>

* Install [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git), [Helm](https://github.com/kubernetes/helm/blob/master/docs/install.md)
(and Tiller) and [Kubernetes client](https://kubernetes.io/docs/tasks/tools/install-kubectl/) (compatible with v1.10) in order to run the 
steps provided in the following quick start guide.<br><br>

* An already setup [Kubernetes cluster](https://kubernetes.io/docs/setup/pick-right-solution/).<br><br>

* Install [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/deploy/). Please note that Helm resources for WSO2 product
deployment patterns are compatible with NGINX Ingress Controller Git release [`nginx-0.22.0`](https://github.com/kubernetes/ingress-nginx/releases/tag/nginx-0.22.0).

* Add the WSO2 Helm chart repository
```
 helm repo add wso2 https://helm.wso2.com && helm repo update
```
  
## Quick Start Guide

>In the context of this document, <br>
>* `KUBERNETES_HOME` will refer to a local copy of the [`wso2/kubernetes-ei`](https://github.com/wso2/kubernetes-ei/)
Git repository. <br>
>* `HELM_HOME` will refer to `<KUBERNETES_HOME>/advanced/ei-pattern-1`. <br>

##### 1. Clone Kubernetes Resources for WSO2 Enterprise Integrator Git repository.

```
git clone https://github.com/wso2/kubernetes-ei.git
```

##### 2. Provide configurations.

a. The default product configurations are available at `<HELM_HOME>/confs` folder. Change the configurations as necessary.

b. Open the `<HELM_HOME>/values.yaml` and provide the following values.

###### MySQL Configurations

| Parameter                                                                   | Description                                                                               | Default Value               |
|-----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.mysql.enabled`                                                        | Enable MySQL chart as a dependency                                                        | true                        |
| `wso2.mysql.host`                                                           | Set MySQL server host                                                                     | wso2ei-rdbms-service-mysql  |
| `wso2.mysql.username`                                                       | Set MySQL server username                                                                 | wso2carbon                  |
| `wso2.mysql.password`                                                       | Set MySQL server password                                                                 | wso2carbon                  |
| `wso2.mysql.driverClass`                                                    | Set JDBC driver class for MySQL                                                           | com.mysql.jdbc.Driver       |
| `wso2.mysql.validationQuery`                                                | Validation query for the MySQL server                                                     | SELECT 1                    |

###### WSO2 Subscription Configurations

| Parameter                                                                   | Description                                                                               | Default Value               |
|-----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.subscription.username`                                                | Your WSO2 Subscription username                                                           | ""                          |
| `wso2.subscription.password`                                                | Your WSO2 Subscription password                                                           | ""                          |

If you do not have active WSO2 subscription do not change the parameters `wso2.deployment.username`, `wso2.deployment.password`. 

###### Centralized Logging Configurations

| Parameter                                                                   | Description                                                                               | Default Value               |
|-----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.centralizedLogging.enabled`                                           | Enable Centralized logging for WSO2 components                                            | true                        |                                                                                         |                             |    
| `wso2.centralizedLogging.logstash.imageTag`                                 | Logstash Sidecar container image tag                                                      | 7.2.0                       |  
| `wso2.centralizedLogging.logstash.elasticsearch.username`                   | Elasticsearch username                                                                    | elastic                     |  
| `wso2.centralizedLogging.logstash.elasticsearch.password`                   | Elasticsearch password                                                                    | changeme                    |  
| `wso2.centralizedLogging.logstash.indexNodeID.wso2ISNode`                   | Elasticsearch EI Node log index ID(index name: ${NODE_ID}-${NODE_IP})                           | wso2                        |

###### Monitoring Configurations

| Parameter                                                                   | Description                                                                               | Default Value               |
|-----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.monitoring.enabled`                                                   | Enable Prometheus monitoring                                                              | false                       |                                                                                         |                             |    
| `wso2.monitoring.prometheus.blackBoxNamespace`                              | Prometheus blackbox exporter namespace                                                    | <RELEASE_NAMESPACE>         |  
| `wso2.monitoring.prometheus.jmxJobName`                                     | Prometheus job name                                                                       | jmx                         |  
| `wso2.monitoring.prometheus.serviceMonitor.labels`                          | Prometheus labels for identifying Service Monitor                                         | "release: monitoring"       |  

###### Integrator Profile Configurations

| Parameter                                                                   | Description                                                                               | Default Value               |
|-----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.deployment.wso2ei.imageName`                                          | Image name for EI node                                                                    | wso2ei                      |
| `wso2.deployment.wso2ei.imageTag`                                           | Image tag for EI node                                                                     | 6.6.0                       |
| `wso2.deployment.wso2ei.replicas`                                           | Number of replicas for EI node                                                            | 1                           |
| `wso2.deployment.wso2ei.minReadySeconds`                                    | Refer to [doc](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.10/#deploymentspec-v1-apps)| 1  75                        |
| `wso2.deployment.wso2ei.strategy.rollingUpdate.maxSurge`                    | Refer to [doc](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.10/#deploymentstrategy-v1-apps) | 1                           |
| `wso2.deployment.wso2ei.strategy.rollingUpdate.maxUnavailable`              | Refer to [doc](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.10/#deploymentstrategy-v1-apps) | 0                           |
| `wso2.deployment.wso2ei.livenessProbe.initialDelaySeconds`                  | Initial delay for the live-ness probe for EI node                                         | 40                           |
| `wso2.deployment.wso2ei.livenessProbe.periodSeconds`                        | Period of the live-ness probe for EI node                                                 | 10                           |
| `wso2.deployment.wso2ei.readinessProbe.initialDelaySeconds`                 | Initial delay for the readiness probe for EI node                                         | 40                           |
| `wso2.deployment.wso2ei.readinessProbe.periodSeconds`                       | Period of the readiness probe for EI node                                                 | 10                           |
| `wso2.deployment.wso2ei.imagePullPolicy`                                    | Refer to [doc](https://kubernetes.io/docs/concepts/containers/images#updating-images)     | Always                       |
| `wso2.deployment.wso2ei.resources.requests.memory`                          | The minimum amount of memory that should be allocated for a Pod                           | 1Gi                          |
| `wso2.deployment.wso2ei.resources.requests.cpu`                             | The minimum amount of CPU that should be allocated for a Pod                              | 2000m                        |
| `wso2.deployment.wso2ei.resources.limits.memory`                            | The maximum amount of memory that should be allocated for a Pod                           | 2Gi                          |
| `wso2.deployment.wso2ei.resources.limits.cpu`                               | The maximum amount of CPU that should be allocated for a Pod                              | 2000m                        |

**Note**: The above mentioned default, minimum resource amounts for running WSO2 Enterprise Integrator server profiles are based on its [official documentation](https://docs.wso2.com/display/EI650/Installation+Prerequisites).

###### Analytics Worker Instance One Runtime Configurations

| Parameter                                                                    | Description                                                                               | Default Value               |
|------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.deployment.wso2eiAnalyticsWorker1.imageName`                           | Image name for EI Analytics Worker node                                                   | wso2ei-analytics-worker     |
| `wso2.deployment.wso2eiAnalyticsWorker1.imageTag`                            | Image tag for EI Analytics Worker node                                                    | 6.6.0                       |
| `wso2.deployment.wso2eiAnalyticsWorker1.replicas`                            | Number of replicas for EI node                                                            | 1                           |
| `wso2.deployment.wso2eiAnalyticsWorker1.minReadySeconds`                     | Refer to [doc](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.10/#deploymentspec-v1-apps)|  30        |
| `wso2.deployment.wso2eiAnalyticsWorker1.strategy.rollingUpdate.maxSurge`     | Refer to [doc](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.10/#deploymentstrategy-v1-apps) | 2     |
| `wso2.deployment.wso2eiAnalyticsWorker1.strategy.rollingUpdate.maxUnavailable`  | Refer to [doc](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.10/#deploymentstrategy-v1-apps) | 0                           |
| `wso2.deployment.wso2eiAnalyticsWorker1.livenessProbe.initialDelaySeconds`   | Initial delay for the live-ness probe for EI Analytics Worker node                        | 20                           |
| `wso2.deployment.wso2eiAnalyticsWorker1.livenessProbe.periodSeconds`         | Period of the live-ness probe for EI Analytics Worker node                                | 10                           |
| `wso2.deployment.wso2eiAnalyticsWorker1.readinessProbe.initialDelaySeconds`  | Initial delay for the readiness probe for EI Analytics Worker node                        | 20                           |
| `wso2.deployment.wso2eiAnalyticsWorker1.readinessProbe.periodSeconds`        | Period of the readiness probe for EI Analytics Worker node                                | 10                           |
| `wso2.deployment.wso2eiAnalyticsWorker1.imagePullPolicy`                     | Refer to [doc](https://kubernetes.io/docs/concepts/containers/images#updating-images)     | Always                       |
| `wso2.deployment.wso2eiAnalyticsWorker1.resources.requests.memory`           | The minimum amount of memory that should be allocated for a Pod                           | 4Gi                          |
| `wso2.deployment.wso2eiAnalyticsWorker1.resources.requests.cpu`              | The minimum amount of CPU that should be allocated for a Pod                              | 2000m                        |
| `wso2.deployment.wso2eiAnalyticsWorker1.resources.limits.memory`             | The maximum amount of memory that should be allocated for a Pod                           | 4Gi                          |
| `wso2.deployment.wso2eiAnalyticsWorker1.resources.limits.cpu`                | The maximum amount of CPU that should be allocated for a Pod                              | 2000m                        |

###### Analytics Worker Instance Two Runtime Configurations

| Parameter                                                                    | Description                                                                               | Default Value               |
|------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.deployment.wso2eiAnalyticsWorker2.imageName`                           | Image name for EI Analytics Worker node                                                   | wso2ei-analytics-worker     |
| `wso2.deployment.wso2eiAnalyticsWorker2.imageTag`                            | Image tag for EI Analytics Worker node                                                    | 6.6.0                       |
| `wso2.deployment.wso2eiAnalyticsWorker2.replicas`                            | Number of replicas for EI node                                                            | 1                           |
| `wso2.deployment.wso2eiAnalyticsWorker2.minReadySeconds`                     | Refer to [doc](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.10/#deploymentspec-v1-apps)|  30        |
| `wso2.deployment.wso2eiAnalyticsWorker2.strategy.rollingUpdate.maxSurge`     | Refer to [doc](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.10/#deploymentstrategy-v1-apps) | 2     |
| `wso2.deployment.wso2eiAnalyticsWorker2.strategy.rollingUpdate.maxUnavailable`  | Refer to [doc](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.10/#deploymentstrategy-v1-apps) | 0                           |
| `wso2.deployment.wso2eiAnalyticsWorker2.livenessProbe.initialDelaySeconds`   | Initial delay for the live-ness probe for EI Analytics Worker node                        | 20                           |
| `wso2.deployment.wso2eiAnalyticsWorker2.livenessProbe.periodSeconds`         | Period of the live-ness probe for EI Analytics Worker node                                | 10                           |
| `wso2.deployment.wso2eiAnalyticsWorker2.readinessProbe.initialDelaySeconds`  | Initial delay for the readiness probe for EI Analytics Worker node                        | 20                           |
| `wso2.deployment.wso2eiAnalyticsWorker2.readinessProbe.periodSeconds`        | Period of the readiness probe for EI Analytics Worker node                                | 10                           |
| `wso2.deployment.wso2eiAnalyticsWorker2.imagePullPolicy`                     | Refer to [doc](https://kubernetes.io/docs/concepts/containers/images#updating-images)     | Always                       |
| `wso2.deployment.wso2eiAnalyticsWorker2.resources.requests.memory`           | The minimum amount of memory that should be allocated for a Pod                           | 4Gi                          |
| `wso2.deployment.wso2eiAnalyticsWorker2.resources.requests.cpu`              | The minimum amount of CPU that should be allocated for a Pod                              | 2000m                        |
| `wso2.deployment.wso2eiAnalyticsWorker2.resources.limits.memory`             | The maximum amount of memory that should be allocated for a Pod                           | 4Gi                          |
| `wso2.deployment.wso2eiAnalyticsWorker2.resources.limits.cpu`                | The maximum amount of CPU that should be allocated for a Pod                              | 2000m                        |

###### Analytics Dashboard Runtime Configurations

| Parameter                                                                   | Description                                                                               | Default Value               |
|-----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.deployment.wso2eiAnalyticsDashbaord.imageName`                        | Image name for EI node                                                                    | wso2ei                      |
| `wso2.deployment.wso2eiAnalyticsDashbaord.imageTag`                         | Image tag for EI node                                                                     | 6.6.0                       |
| `wso2.deployment.wso2eiAnalyticsDashbaord.replicas`                         | Number of replicas for EI node                                                            | 2                           |
| `wso2.deployment.wso2eiAnalyticsDashbaord.minReadySeconds`                  | Refer to [doc](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.10/#deploymentspec-v1-apps)| 1  30                        |
| `wso2.deployment.wso2eiAnalyticsDashbaord.strategy.rollingUpdate.maxSurge`  | Refer to [doc](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.10/#deploymentstrategy-v1-apps) | 2                           |
| `wso2.deployment.wso2eiAnalyticsDashbaord.strategy.rollingUpdate.maxUnavailable`              | Refer to [doc](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.10/#deploymentstrategy-v1-apps) | 0                           |
| `wso2.deployment.wso2eiAnalyticsDashbaord.livenessProbe.initialDelaySeconds`| Initial delay for the live-ness probe for EI node                                         | 20                           |
| `wso2.deployment.wso2eiAnalyticsDashbaord.livenessProbe.periodSeconds`      | Period of the live-ness probe for EI node                                                 | 10                           |
| `wso2.deployment.wso2eiAnalyticsDashbaord.readinessProbe.initialDelaySeconds`| Initial delay for the readiness probe for EI node                                        | 20                           |
| `wso2.deployment.wso2eiAnalyticsDashbaord.readinessProbe.periodSeconds`     | Period of the readiness probe for EI node                                                 | 10                           |
| `wso2.deployment.wso2eiAnalyticsDashbaord.imagePullPolicy`                  | Refer to [doc](https://kubernetes.io/docs/concepts/containers/images#updating-images)     | Always                       |
| `wso2.deployment.wso2eiAnalyticsDashbaord.resources.requests.memory`        | The minimum amount of memory that should be allocated for a Pod                           | 4Gi                          |
| `wso2.deployment.wso2eiAnalyticsDashbaord.resources.requests.cpu`           | The minimum amount of CPU that should be allocated for a Pod                              | 2000m                        |
| `wso2.deployment.wso2eiAnalyticsDashbaord.resources.limits.memory`          | The maximum amount of memory that should be allocated for a Pod                           | 4Gi                          |
| `wso2.deployment.wso2eiAnalyticsDashbaord.resources.limits.cpu`             | The maximum amount of CPU that should be allocated for a Pod                              | 2000m                        |

**Note**: The above mentioned default, minimum resource amounts for running WSO2 Stream Processor server profiles
(Dashboard and Worker)are based on its [official documentation](https://docs.wso2.com/display/SP440/Installation+Prerequisites).
Also, see the [official documentation](https://docs.wso2.com/display/SP440/Performance+Analysis+Results) on WSO2 Stream Processor
based Performance Analysis and Resource recommendations and tune the limits according to your needs, where necessary

###### Kubernetes Configurations

| Parameter                                                                   | Description                                                                               | Default Value               |
|-----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `kubernetes.svcaccount`                                                     | Kubernetes Service Account in the `namespace` to which product instance pods are attached | wso2svc-account             |

The parameters above indicate configuration values for the Integrator profile. Similar configurations are used in the Analytics Dashboard and Worker profiles as well.

##### 3. Deploy WSO2 Enterprise Integrator with Analytics.

```
helm install --dep-up --name <RELEASE_NAME> <HELM_HOME>/ei-pattern-1 --namespace <NAMESPACE>
```

`NAMESPACE` should be the Kubernetes Namespace in which the resources are deployed.

##### 4. Access Management Console.

Default deployment will expose `<RELEASE_NAME>-integrator`, `<RELEASE_NAME>-gateway` and `<RELEASE_NAME>-analytics-dashboard` hosts.

To access the console in the environment,

a. Obtain the external IP (`EXTERNAL-IP`) of the Ingress resources by listing down the Kubernetes Ingresses.

```
kubectl get ing -n <NAMESPACE>
```

e.g.

```
NAME                                                   HOSTS                                   ADDRESS        PORTS     AGE
wso2ei-pattern-1-analytics-dashboard-ingress           <RELEASE_NAME>-analytics-dashboard      <EXTERNAL-IP>  80, 443   2m
wso2ei-pattern-1-integrator-gateway-tls-ingress        <RELEASE_NAME>-gateway                  <EXTERNAL-IP>  80, 443   2m
wso2ei-pattern-1-integrator-ingress                    <RELEASE_NAME>-integrator               <EXTERNAL-IP>  80, 443   2m
```

b. Add the above host as an entry in /etc/hosts file as follows:

```
<EXTERNAL-IP>	<RELEASE_NAME>-analytics-dashboard
<EXTERNAL-IP>	<RELEASE_NAME>-gateway
<EXTERNAL-IP>	<RELEASE_NAME>-integrator
```

c. Try navigating to `https://<RELEASE_NAME>-integrator/carbon` and `https://<RELEASE_NAME>-analytics-dashboard/portal` from your favorite browser.

## Enabling Centralized Logging

Centralized logging with Logstash and Elasticsearch is disabled by default. However, if it is required to be enabled, 
the following steps should be followed.

1. Set `centralizedLogging.enabled` to `true` in the [values.yaml](values.yaml) file.
2. Add elasticsearch Helm repository to download sub-charts required for Centralized logging.
```
helm repo add elasticsearch https://helm.elastic.co
```
3. Add the following dependencies in the [requirements.yaml](requirements.yaml) file.
```
dependencies:
  - name: kibana
    version: "7.2.1-0"
    repository: "https://helm.elastic.co"
    condition: wso2.centralizedLogging.enabled
  - name: elasticsearch
    version: "7.2.1-0"
    repository: "https://helm.elastic.co"
    condition: wso2.centralizedLogging.enabled

```
4. Add override configurations for Elasticsearch in the [values.yaml](values.yaml) file.
```
wso2:
  ( ... )
  
elasticsearch:
  clusterName: wso2-elasticsearch
```
