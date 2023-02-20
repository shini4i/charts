# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.9] - 2023-02-20
### Added
- Support for deploying app as a StatefulSet

## [0.0.8] - 2022-08-16
### Fixed
- keda-scaledobject.yaml filename and default value

## [0.0.7] - 2022-08-16
### Added
- Support for Keda ScaledObject

## [0.0.6] - 2022-04-25
### Added
- Shared emptyDir
- Support for defining additional volumes
- Support for both lifecycle rules and init containers
- Support for defining deployment strategy

## [0.0.5] - 2022-03-26
### Changed
- Job image structure change to support argocd-image-updater

## [0.0.4] - 2022-03-20
### Added
- Support for sidecar containers

## [0.0.3] - 2022-03-12
### Fixed
- Ingress and IngressRoute service port mapping
## [0.0.2] - 2022-03-12
### Added
- Support for liveness and readiness probes configuration
- revisionHistoryLimit configuration
- podmonitor basic configuration

## [0.0.1] - 2022-03-11
### Added
- Initial version
