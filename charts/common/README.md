# common

![Version: 0.0.4](https://img.shields.io/badge/Version-0.0.4-informational?style=flat-square) ![Type: library](https://img.shields.io/badge/Type-library-informational?style=flat-square)

A Helm chart library with some common templates

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| configMap.data | object | `{}` | values of the resulting ConfigMap |
| configMap.nameOverride | string | `""` | resulting ConfigMap name override |
| job.annotations."helm.sh/hook" | string | `"pre-upgrade"` |  |
| job.backoffLimit | int | `1` |  |
| job.command[0] | string | `"curl"` |  |
| job.command[1] | string | `"https://ifconfig.me"` |  |
| job.env | list | `[]` | Environment variables to pass to job container |
| job.envFrom | list | `[]` | envFrom to pass to job container |
| job.image.pullPolicy | string | `"IfNotPresent"` |  |
| job.image.repository | string | `"curlimages/curl"` |  |
| job.image.tag | string | `"7.85.0"` |  |
| job.imagePullSecrets | list | `[]` |  |
| job.restartPolicy | string | `"Never"` |  |
| keda.advanced | object | `{}` |  |
| keda.fallback | object | `{}` |  |
| keda.maxReplicaCount | int | `5` |  |
| keda.minReplicaCount | int | `2` |  |
| keda.triggers | list | `[]` |  |
| podMonitor.labels | object | `{}` |  |
| podMonitor.podMetricsEndpoints | list | `[]` |  |

