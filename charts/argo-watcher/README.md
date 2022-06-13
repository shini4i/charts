# argo-watcher

![Version: 0.1.16](https://img.shields.io/badge/Version-0.1.16-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.0.10](https://img.shields.io/badge/AppVersion-v0.0.10-informational?style=flat-square)

A Helm chart for deploying argo-watcher

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| argo.secretName | string | `""` | Pre-created secret with ARGO_PASSWORD variable |
| argo.skipTlsVerify | bool | `false` | If ssl certificate should be verified |
| argo.timeout | int | `300` | How long to wait for deployment to be finished |
| argo.url | string | `"https://argocd.example.com"` |  |
| argo.username | string | `"user"` |  |
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
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podMonitor.enabled | bool | `false` |  |
| podMonitor.labels | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| postgres.enabled | bool | `false` | Sets STATE_TYPE to postgres |
| postgres.host | string | `""` |  |
| postgres.name | string | `""` |  |
| postgres.port | int | `5432` |  |
| postgres.secretName | string | `""` | Pre-created secret with DB_PASSWORD variable |
| postgres.user | string | `""` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| revisionHistory | int | `1` |  |
| securityContext | object | `{}` |  |
| service.containerPort | int | `8080` |  |
| service.port | int | `80` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| tolerations | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.9.1](https://github.com/norwoodj/helm-docs/releases/v1.9.1)