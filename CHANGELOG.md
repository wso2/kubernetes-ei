# Changelog
All notable changes to this project 6.6.x per each release will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

## [v6.6.0.3] - 2020-12-17

### Changed

- Fix incorrect carbon.sh overrides (refer [issue](https://github.com/wso2/kubernetes-ei/issues/238) ).
- Fix incorrect properties in serviceMonitor (refer [issue](https://github.com/wso2/kubernetes-ei/issues/239)).
- Fix image name and tag generation to use custom registry (refer [issue](https://github.com/wso2/kubernetes-ei/issues/240)).

## [v6.6.0.2] - 2020-10-27

### Changed

- Upgrade MySQL chart to support newer Kubernetes versions (refer [issue](https://github.com/wso2/kubernetes-ei/issues/233) ).
- Add JVM parameter to force the use of TLS 1.2 client (refer [issue](https://github.com/wso2/kubernetes-ei/issues/230)).
- Use correct wso2server.sh for message broker (refer [issue](https://github.com/wso2/kubernetes-ei/issues/234)).

## [v6.6.0.1] - 2019-12-20
- Add Kubernetes/Helm resources for WSO2 Enterprise Integrator v6.6.0

## [v6.5.0.3] - 2019-08-31

### Added
- Added MySQL Helm chart as dependencies for deployment patterns.
- Added InitContainer support in Helm resources.
- Introduced Logstash for log aggregation and analysis.
- Added datasource configurations to values.yaml files.
- Added descriptive comments to the values.yaml file of each Helm chart.

### Changed
- Promoted Helm resources as the single source of Kubernetes resource installation.
- Parameterized datasource and clustering configurations.
- Parameterized Kubernetes deployment definitions.
- Set resource requests and limits for Kubernetes deployments.
- Parameterized Ingress host names.
- Formalized naming conventions for Helm resources.

### Removed
- Removed sharing of persistent volumes in deployment patterns.

For detailed information on the tasks carried out during this release, please see the GitHub milestone
[6.6.0.1](https://github.com/wso2/kubernetes-ei/milestone/8).

## [v6.5.0.2] - 2019-06-20

### Added
- Added resources for deployment of kubernetes manifests and helm charts on AKS using Azurefiles as persistent storage instead of NFS.
- Kubernetes resources for a simplified, WSO2 Integrator deployment
- Kubernetes resources for WSO2 Integrator (EI) 
- Helm resources for WSO2 Integrator (EI)
- Integrate support in Kubernetes resources for users with and without WSO2 subscriptions
- Integrate support in Helm resources for users with and without WSO2 subscriptions

[v6.5.0.3]: https://github.com/wso2/kubernetes-ei/compare/v6.5.0.2...v6.5.0.3
[v6.6.0.1]: https://github.com/wso2/kubernetes-ei/compare/v6.5.0.3...v6.6.0.1
[v6.6.0.2]: https://github.com/wso2/kubernetes-ei/compare/v6.6.0.2...v6.6.0.1
[v6.6.0.3]: https://github.com/wso2/kubernetes-ei/compare/v6.6.0.3...v6.6.0.2
