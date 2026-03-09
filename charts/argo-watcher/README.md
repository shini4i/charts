# argo-watcher

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.9.1](https://img.shields.io/badge/AppVersion-v0.9.1-informational?style=flat-square)

A Helm chart for deploying argo-watcher

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Vadim Gedz | <github@shini4i.dev> | <https://github.com/shini4i> |

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
| argo.url | string | `"https://argocd.example.com"` |  |
| argo.urlAlias | string | `""` | An alias that will be used to generate url for ArgoCD app |
| extraEnvs | list | `[]` | Additional environment variables to add to the container (supports both value and valueFrom) |
| fullnameOverride | string | `""` |  |
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
| livenessProbe | object | `{"enabled":true,"failureThreshold":3,"initialDelaySeconds":5,"path":"/healthz","periodSeconds":30,"timeoutSeconds":5}` | Liveness probe configuration |
| logLevel | string | `"info"` |  |
| migration.backoffLimit | int | `5` |  |
| migration.podSecurityContext.runAsNonRoot | bool | `true` |  |
| migration.podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| migration.resources | object | `{}` |  |
| migration.restartPolicy | string | `"OnFailure"` |  |
| migration.securityContext.allowPrivilegeEscalation | bool | `false` |  |
| migration.securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| migration.securityContext.readOnlyRootFilesystem | bool | `true` |  |
| migration.securityContext.runAsNonRoot | bool | `true` |  |
| migration.securityContext.runAsUser | int | `1000` |  |
| nameOverride | string | `""` |  |
| networkPolicies.additionalRules | list | `[]` | additional ingress rules to add to the network policy (access will be granted to .Values.service.containerPort) |
| networkPolicies.enabled | bool | `false` | If network policies should be created |
| nodeSelector | object | `{}` |  |
| persistence.accessModes | list | `["ReadWriteOnce"]` | The access modes for the persistent volume claim |
| persistence.annotations | object | `{}` | Annotations to add to the persistent volume claim |
| persistence.enabled | bool | `true` | Enable persistence using a Persistent Volume Claim |
| persistence.mountPath | string | `"/data"` | The path to mount the persistent volume in the container |
| persistence.size | string | `"1Gi"` | The size of the persistent volume claim |
| podAnnotations | object | `{}` |  |
| podDisruptionBudget | object | `{"enabled":false}` | PodDisruptionBudget configuration |
| podMonitor.enabled | bool | `false` |  |
| podMonitor.labels | object | `{}` |  |
| podSecurityContext | object | `{"fsGroup":65532}` | Duration in seconds the pod needs to terminate gracefully terminationGracePeriodSeconds: 30 |
| postgres.enabled | bool | `false` | Sets STATE_TYPE to postgres |
| postgres.host | string | `""` |  |
| postgres.name | string | `""` |  |
| postgres.port | int | `5432` |  |
| postgres.secretKey | string | `""` | Support for an optional key override (this specific key would be exposed to DB_PASSWORD) |
| postgres.secretName | string | `""` | Pre-created secret with DB_PASSWORD variable |
| postgres.user | string | `""` |  |
| readinessProbe | object | `{"enabled":true,"failureThreshold":3,"initialDelaySeconds":3,"path":"/healthz","periodSeconds":10,"timeoutSeconds":3}` | Readiness probe configuration |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| revisionHistory | int | `1` |  |
| scheduledLockdown | list | `[]` | Schedule lockdown configuration |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.readOnlyRootFilesystem | bool | `true` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `65532` |  |
| securityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| service.containerPort | int | `8080` |  |
| service.port | int | `80` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.automountServiceAccountToken | bool | `true` | Whether to automount the service account token |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| startupProbe | object | `{"enabled":false,"failureThreshold":30,"path":"/healthz","periodSeconds":5,"timeoutSeconds":3}` | Startup probe configuration |
| tolerations | list | `[]` |  |
| topologySpreadConstraints | list | `[]` |  |
| updater | object | `{"commitAuthor":"argo-watcher","commitEmail":"argo-watcher@example.com","extraKnownHosts":[],"knownHostsConfigMap":"","knownHostsKey":"ssh_known_hosts","sshKey":"sshPrivateKey","sshSecretName":""}` | Configuration for argo image updater logic replacement (optional) |
| updater.commitAuthor | string | `"argo-watcher"` | User to use for git operations |
| updater.commitEmail | string | `"argo-watcher@example.com"` | Email to use for git operations |
| updater.extraKnownHosts | list | `[]` | Extra known hosts to add to ssh config, will be skipped if knownHostsConfigMap is set (optional) |
| updater.knownHostsConfigMap | string | `""` | Known hosts configmap override (optional) |
| updater.knownHostsKey | string | `"ssh_known_hosts"` | Known hosts configmap key (optional) |
| updater.sshKey | string | `"sshPrivateKey"` | Key to mount from sshSecretName |
| updater.sshSecretName | string | `""` | Pre-created secret with ssh key |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
