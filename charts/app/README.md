# app

![Version: 0.4.0](https://img.shields.io/badge/Version-0.4.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

A Helm chart for a simple app deployment

**Homepage:** <https://github.com/shini4i/charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Vadim Gedz | <github@shini4i.dev> | <https://github.com/shini4i> |

## Source Code

* <https://github.com/shini4i/charts/tree/main/charts/app>

## Requirements

Kubernetes: `>=1.23.0-0`

| Repository | Name | Version |
|------------|------|---------|
| https://shini4i.github.io/charts/ | network-policies | 0.0.6 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| app.additionalVolumeMounts | list | `[]` | raw yaml definition of additional volume mounts (requires matching volume definition) |
| app.args | list | `[]` | A primary container args |
| app.automountServiceAccountToken | string | `nil` | Whether the app pods get an API token mounted. Left unset to keep the Kubernetes default |
| app.command | list | `[]` | A primary container command override |
| app.deployment | object | `{"maxSurge":1,"maxUnavailable":"25%","progressDeadlineSeconds":null,"strategy":"RollingUpdate"}` | Deployment configuration (only used if kind is set to Deployment) |
| app.deployment.progressDeadlineSeconds | string | `nil` | Seconds a rollout may stall before it is marked failed |
| app.env | list | `[]` | Environment variables to pass to main app container |
| app.envFrom | list | `[]` | envFrom to pass to main app container |
| app.kind | string | `"Deployment"` | Allowed values: Deployment or StatefulSet |
| app.lifecycle | object | `{}` |  |
| app.livenessProbe | object | `{}` | Liveness probe configuration |
| app.minReadySeconds | string | `nil` | Seconds a new pod must stay ready before it counts as available |
| app.podLabels | object | `{}` | Labels to add to the app pods on top of the common chart labels. The selector labels cannot be overridden |
| app.priorityClassName | string | `""` | PriorityClass for the app pods |
| app.readinessProbe | object | `{}` | Readiness probe configuration. A rolling update has no gate without one |
| app.sharedVolume.enabled | bool | `true` | Mount an emptyDir at /shared in the primary container |
| app.startupProbe | object | `{}` | Startup probe configuration |
| app.statefulSet | object | `{"headless":{"enabled":false},"persistence":{"enabled":false,"volumes":[]},"podManagementPolicy":"OrderedReady","strategy":"RollingUpdate"}` | StatefulSet configuration (only used if kind is set to StatefulSet) |
| app.statefulSet.headless.enabled | bool | `false` | Create a headless service and point spec.serviceName at it, which is what stable per-pod DNS requires. Off by default because spec.serviceName is immutable: on an existing release the StatefulSet has to be recreated |
| app.statefulSet.persistence.volumes | list | `[]` | Persistent volumes configuration. accessModes defaults to ["ReadWriteOnce"]; size is required |
| app.terminationGracePeriodSeconds | string | `nil` | Grace period for a terminating pod. Should exceed the time the app needs to drain in-flight requests |
| app.topologySpreadConstraints | list | `[]` | Raw yaml definition of topology spread constraints |
| autoscaling.behavior | object | `{}` | Raw yaml definition of the HPA scaling behavior |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"traefik/whoami"` |  |
| image.tag | string | `"v1.10.2"` | Image tag. Leave empty to pin the image by digest through image.repository |
| imagePullSecrets | list | `[]` |  |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"exposedPort":80,"hosts":[],"tls":[]}` | Classical ingress definition |
| ingress.exposedPort | int | `80` | Port to use with ingress |
| ingressRoute | object | `{"annotations":{},"enabled":false,"entryPoint":"websecure","exposedPort":80,"host":"example.com","labels":{},"tls":{"enabled":true},"tlsSecret":"example-com-tls"}` | Traefik ingressRoute definition |
| ingressRoute.exposedPort | int | `80` | Port to use with ingressRoute |
| ingressRoute.tls.enabled | bool | `true` | Terminate TLS on the route. Turn off for a plain HTTP entryPoint |
| ingressRoute.tlsSecret | string | `"example-com-tls"` | TLS secret for the route. Empty falls back to the entryPoint certificate |
| initContainers | list | `[]` | Raw yaml definition of init containers |
| job.activeDeadlineSeconds | string | `nil` | Seconds a job may run before it is terminated and marked failed |
| job.affinity | object | `{}` | Affinity to use for the job pod |
| job.annotations | object | `{}` | Annotations to add to the job. Set "helm.sh/hook" here to run the job as a Helm hook |
| job.args | list | `[]` | A job container args |
| job.backoffLimit | int | `1` |  |
| job.command | list | `["curl","https://ifconfig.me"]` | A job container command override |
| job.enabled | bool | `false` |  |
| job.env | list | `[]` | Environment variables to pass to job container |
| job.envFrom | list | `[]` | envFrom to pass to job container |
| job.image.pullPolicy | string | `"IfNotPresent"` |  |
| job.image.repository | string | `"curlimages/curl"` |  |
| job.image.tag | string | `"8.7.1"` |  |
| job.imagePullSecrets | list | `[]` |  |
| job.labels | object | `{}` | Labels to add to the job on top of the common chart labels |
| job.nodeSelector | object | `{}` | NodeSelector to use for the job pod |
| job.podAnnotations | object | `{}` | Annotations to add to the job pod |
| job.podLabels | object | `{}` | Labels to add to the job pod on top of instance, managed-by and component. app.kubernetes.io/name is ignored: it would enrol job pods as Service endpoints |
| job.podSecurityContext | object | `{}` | podSecurityContext to use for the job pod |
| job.resources | object | `{}` | Resources to request for the job container |
| job.restartPolicy | string | `"Never"` |  |
| job.securityContext | object | `{}` | securityContext to use for the job container |
| job.serviceAccountName | string | `""` | An override for the job service account |
| job.tolerations | list | `[]` | Tolerations to use for the job pod |
| job.ttlSecondsAfterFinished | string | `nil` | Seconds to keep a finished job before the TTL controller removes it |
| job.volumeMounts | list | `[]` | Raw yaml definition of volume mounts for the job container |
| job.volumes | list | `[]` | Raw yaml definition of volumes available to the job pod |
| keda.advanced | object | `{}` |  |
| keda.cooldownPeriod | int | `300` | Seconds to wait after the last trigger fired before scaling down |
| keda.enabled | bool | `false` |  |
| keda.fallback | object | `{}` |  |
| keda.maxReplicaCount | int | `5` |  |
| keda.minReplicaCount | int | `2` |  |
| keda.pollingInterval | int | `30` | Seconds between trigger evaluations |
| keda.triggers | list | `[]` | At least one trigger is required when keda is enabled |
| middleware | object | `{"enabled":false,"existingMiddlewares":[],"labels":{},"sourceRange":[]}` | Whitelist Middleware definition |
| middleware.existingMiddlewares | list | `[]` | Names of existing middlewares, attached after the whitelist. Needs enabled: true |
| middleware.sourceRange | list | `[]` | CIDRs allowed to reach the route. A Middleware is created only when this is non-empty and middleware.enabled is true |
| nameOverride | string | `""` |  |
| network-policies | object | `{}` | Network policies configuration |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podDisruptionBudget | object | `{"annotations":{},"enabled":false,"maxUnavailable":null,"minAvailable":null,"unhealthyPodEvictionPolicy":null}` | PodDisruptionBudget. Set exactly one of minAvailable or maxUnavailable |
| podDisruptionBudget.unhealthyPodEvictionPolicy | string | `nil` | AlwaysAllow lets a drain evict already-unhealthy pods. Needs Kubernetes 1.27 |
| podMonitor.enabled | bool | `false` |  |
| podMonitor.labels | object | `{}` |  |
| podMonitor.podMetricsEndpoints | list | `[]` | Endpoints to scrape. At least one is required when podMonitor is enabled |
| podSecurityContext | object | `{}` |  |
| rawObject | list | `[]` | Raw yaml definition used to deploy something that is not supported by this chart |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| revisionHistoryLimit | int | `3` | Number of superseded ReplicaSets or ControllerRevisions kept for rollbacks |
| securityContext | object | `{}` |  |
| service.annotations | object | `{}` | Annotations to add to the service |
| service.ports | list | `[{"containerPort":80,"name":"http","port":80}]` | Service ports. containerPort defaults to port, protocol to TCP; appProtocol and nodePort are optional |
| service.sessionAffinity | string | `""` | Service sessionAffinity, e.g. ClientIP. Unset means None |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.automountServiceAccountToken | string | `nil` | Whether pods using this service account get an API token mounted. Left unset to keep the Kubernetes default (true); set to false for workloads that never call the API server |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` |  |
| sideCars | list | `[]` | Raw yaml definition of sidecar containers |
| tolerations | list | `[]` |  |
| traefik.apiVersion | string | `"traefik.io/v1alpha1"` | CRD API group used by the ingressRoute and middleware templates. Traefik v3 serves traefik.io/v1alpha1; set traefik.containo.us/v1alpha1 for Traefik v2 |
| volumes | list | `[]` | Raw yaml definition of additional volumes |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
