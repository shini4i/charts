# app

![Version: 0.2.1](https://img.shields.io/badge/Version-0.2.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

A Helm chart for a simple app deployment

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Vadim Gedz | <github@shini4i.dev> | <https://github.com/shini4i> |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://shini4i.github.io/charts/ | network-policies | 0.0.6 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| app.additionalVolumeMounts | list | `[]` | raw yaml definition of additional volume mounts (requires matching volume definition) |
| app.args | list | `[]` | A primary container args |
| app.command | list | `[]` | A primary container command override |
| app.deployment | object | `{"maxSurge":1,"maxUnavailable":"25%","strategy":"RollingUpdate"}` | Deployment configuration (only used if kind is set to Deployment) |
| app.env | list | `[]` | Environment variables to pass to main app container |
| app.envFrom | list | `[]` | envFrom to pass to main app container |
| app.kind | string | `"Deployment"` | Allowed values: Deployment or StatefulSet |
| app.lifecycle | object | `{}` |  |
| app.livenessProbe | object | `{}` | Deployments livenessProbe configuration |
| app.readinessProbe | object | `{}` | Deployments readinessProbe configuration |
| app.startupProbe | object | `{}` | Deployments startupProbe configuration |
| app.statefulSet | object | `{"persistence":{"enabled":false,"volumes":[]},"strategy":"RollingUpdate"}` | StatefulSet configuration (only used if kind is set to StatefulSet) |
| app.statefulSet.persistence.volumes | list | `[]` | Persistent volumes configuration |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"traefik/whoami"` |  |
| image.tag | string | `"v1.10.2"` |  |
| imagePullSecrets | list | `[]` |  |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"exposedPort":80,"hosts":[],"tls":[]}` | Classical ingress definition |
| ingress.exposedPort | int | `80` | Port to use with ingress |
| ingressRoute | object | `{"annotations":{},"enabled":false,"entryPoint":"websecure","exposedPort":80,"host":"example.com","labels":{},"tlsSecret":"example-com-tls"}` | Traefik v2 ingressRoute definition |
| ingressRoute.exposedPort | int | `80` | Port to use with ingressRoute |
| initContainers | list | `[]` | Raw yaml definition of init containers |
| job.affinity | object | `{}` | Affinity to use for the job pod |
| job.annotations."helm.sh/hook" | string | `"pre-upgrade"` |  |
| job.backoffLimit | int | `1` |  |
| job.command[0] | string | `"curl"` |  |
| job.command[1] | string | `"https://ifconfig.me"` |  |
| job.enabled | bool | `false` |  |
| job.env | list | `[]` | Environment variables to pass to job container |
| job.envFrom | list | `[]` | envFrom to pass to job container |
| job.image.pullPolicy | string | `"IfNotPresent"` |  |
| job.image.repository | string | `"curlimages/curl"` |  |
| job.image.tag | string | `"8.7.1"` |  |
| job.imagePullSecrets | list | `[]` |  |
| job.nodeSelector | object | `{}` | NodeSelector to use for the job pod |
| job.podSecurityContext | object | `{}` | podSecurityContext to use for the job pod |
| job.restartPolicy | string | `"Never"` |  |
| job.securityContext | object | `{}` | securityContext to use for the job pod |
| job.serviceAccountName | string | `""` | An override for the job service account |
| job.tolerations | list | `[]` | Tolerations to use for the job pod |
| keda.advanced | object | `{}` |  |
| keda.enabled | bool | `false` |  |
| keda.fallback | object | `{}` |  |
| keda.maxReplicaCount | int | `5` |  |
| keda.minReplicaCount | int | `2` |  |
| keda.triggers | list | `[]` |  |
| middleware | object | `{"enabled":false,"existingMiddlewares":{},"labels":{},"sourceRange":[]}` | Whitelist Middleware definition |
| nameOverride | string | `""` |  |
| network-policies | object | `{}` | Network policies configuration |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podMonitor.enabled | bool | `false` |  |
| podMonitor.labels | object | `{}` |  |
| podMonitor.podMetricsEndpoints | list | `[]` |  |
| podSecurityContext | object | `{}` |  |
| rawObject | list | `[]` | Raw yaml definition used to deploy something that is not supported by this chart |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| revisionHistoryLimit | int | `1` |  |
| securityContext | object | `{}` |  |
| service.ports[0].containerPort | int | `80` |  |
| service.ports[0].name | string | `"http"` |  |
| service.ports[0].port | int | `80` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` |  |
| sideCars | list | `[]` | Raw yaml definition of sidecar containers |
| tolerations | list | `[]` |  |
| volumes | list | `[]` | Raw yaml definition of additional volumes |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
