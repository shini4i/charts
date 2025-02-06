# argo-watcher

![Version: 0.7.3](https://img.shields.io/badge/Version-0.7.3-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.9.1](https://img.shields.io/badge/AppVersion-v0.9.1-informational?style=flat-square)

A Helm chart for deploying argo-watcher

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Vadim Gedz | <vadims@linux-tech.io> | <https://github.com/shini4i> |

## Source Code

* <https://github.com/shini4i/argo-watcher>
* <https://github.com/shini4i/charts/tree/main/charts/argo-watcher>

## Requirements

Kubernetes: `>=1.21.0-0`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| argo.apiTimeout | int | `60` | How long to wait for argocd api to respond |
| argo.refreshApp | bool | `true` | If argo-watcher should refresh app during check to make ArgoCD detect changes faster |
| argo.registryProxyUrl | string | `""` | argo-watcher will assume that image can be mutated and will use this value while checking app status |
| argo.secretName | string | `""` | Pre-created secret with ARGO_TOKEN variable and optional ARGO_WATCHER_DEPLOY_TOKEN |
| argo.skipTlsVerify | bool | `false` | If ssl verification should be skipped |
| argo.timeout | int | `300` | How long to wait for deployment to be finished |
| argo.updater | object | `{"commitAuthor":"argo-watcher","commitEmail":"argo-watcher@example.com","extraKnownHosts":[],"knownHostsConfigMap":"","knownHostsKey":"ssh_known_hosts","sshKey":"sshPrivateKey","sshSecretName":""}` | Configuration for argo image updater logic replacement (optional) |
| argo.updater.commitAuthor | string | `"argo-watcher"` | User to use for git operations |
| argo.updater.commitEmail | string | `"argo-watcher@example.com"` | Email to use for git operations |
| argo.updater.extraKnownHosts | list | `[]` | Extra known hosts to add to ssh config, will be skipped if knownHostsConfigMap is set (optional) |
| argo.updater.knownHostsConfigMap | string | `""` | Known hosts configmap override (optional) |
| argo.updater.knownHostsKey | string | `"ssh_known_hosts"` | Known hosts configmap key (optional) |
| argo.updater.sshKey | string | `"sshPrivateKey"` | Key to mount from sshSecretName |
| argo.updater.sshSecretName | string | `""` | Pre-created secret with ssh key |
| argo.url | string | `"https://argocd.example.com"` |  |
| argo.urlAlias | string | `""` | An alias that will be used to generate url for ArgoCD app |
| extraEnvs | list | `[]` | Additional environment variables to add to the container |
| fullnameOverride | string | `""` |  |
| healthChecks.enabled | bool | `true` |  |
| healthChecks.initialDelaySeconds | int | `5` |  |
| healthChecks.periodSeconds | int | `30` |  |
| healthChecks.timeoutSeconds | int | `5` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"ghcr.io/shini4i/argo-watcher"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| logLevel | string | `"info"` |  |
| nameOverride | string | `""` |  |
| networkPolicies.additionalRules | list | `[]` | additional ingress rules to add to the network policy (access will be granted to .Values.service.containerPort) |
| networkPolicies.enabled | bool | `false` | If network policies should be created |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podMonitor.enabled | bool | `false` |  |
| podMonitor.labels | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| postgres.enabled | bool | `false` | Sets STATE_TYPE to postgres |
| postgres.host | string | `""` |  |
| postgres.migration.backoffLimit | int | `5` |  |
| postgres.migration.image.pullPolicy | string | `"IfNotPresent"` |  |
| postgres.migration.image.repository | string | `"migrate/migrate"` |  |
| postgres.migration.image.tag | string | `"v4.17.0"` |  |
| postgres.migration.initContainer.resources | object | `{}` |  |
| postgres.migration.initContainer.securityContext.allowPrivilegeEscalation | bool | `false` |  |
| postgres.migration.initContainer.securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| postgres.migration.initContainer.securityContext.readOnlyRootFilesystem | bool | `true` |  |
| postgres.migration.initContainer.securityContext.runAsNonRoot | bool | `true` |  |
| postgres.migration.initContainer.securityContext.runAsUser | int | `1000` |  |
| postgres.migration.podSecurityContext.runAsNonRoot | bool | `true` |  |
| postgres.migration.podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| postgres.migration.resources | object | `{}` |  |
| postgres.migration.restartPolicy | string | `"OnFailure"` |  |
| postgres.migration.securityContext.allowPrivilegeEscalation | bool | `false` |  |
| postgres.migration.securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| postgres.migration.securityContext.readOnlyRootFilesystem | bool | `true` |  |
| postgres.migration.securityContext.runAsNonRoot | bool | `true` |  |
| postgres.migration.securityContext.runAsUser | int | `1000` |  |
| postgres.name | string | `""` |  |
| postgres.port | int | `5432` |  |
| postgres.secretKey | string | `""` | Support for an optional key override (this specific key would be exposed to DB_PASSWORD) |
| postgres.secretName | string | `""` | Pre-created secret with DB_PASSWORD variable |
| postgres.user | string | `""` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| revisionHistory | int | `1` |  |
| scheduledLockdown | list | `[]` | Schedule lockdown configuration |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.readOnlyRootFilesystem | bool | `true` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `1000` |  |
| securityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| service.containerPort | int | `8080` |  |
| service.port | int | `80` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| tolerations | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.12.0](https://github.com/norwoodj/helm-docs/releases/v1.12.0)
