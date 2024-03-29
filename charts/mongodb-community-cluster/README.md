# mongodb-community-cluster

![Version: 0.2.1](https://img.shields.io/badge/Version-0.2.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 6.0.2](https://img.shields.io/badge/AppVersion-6.0.2-informational?style=flat-square)

A Helm chart for deploying MongoDBCommunity cluster (community-operator)

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Vadim Gedz | <vadims@linux-tech.io> | <https://github.com/shini4i> |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalMongodConfig | object | `{}` | additional MongoDB configuration |
| affinity | object | `{}` |  |
| arbiter.enabled | bool | `false` | If arbiter should be enabled |
| arbiter.replicaCount | int | `1` | Should be less than the value of main replicaCount |
| backups.aws.bucketName | string | `""` |  |
| backups.aws.bucketPrefix | string | `""` |  |
| backups.aws.endpointOverride | string | `""` |  |
| backups.aws.existingSecret | string | `""` | pre-created secret with AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY and optional AWS_DEFAULT_REGION |
| backups.enabled | bool | `false` |  |
| backups.image.repository | string | `"ghcr.io/shini4i/mongodb-tools-awscli"` |  |
| backups.image.tag | string | `"6.0.2"` |  |
| backups.schedule | string | `"30 0 * * *"` |  |
| backups.user | string | `""` | a user to use for backups (from users block) |
| debugPod | object | `{"enabled":false}` | If debug pod with mongosh should be deployed |
| fullnameOverride | string | `""` |  |
| job.backoffLimit | int | `5` |  |
| job.image.repository | string | `"bitnami/kubectl"` |  |
| job.image.tag | string | `"1.25.3"` |  |
| job.restartPolicy | string | `"OnFailure"` |  |
| metrics.additionalLabels | object | `{}` | labels to add to ServiceMonitor |
| metrics.enabled | bool | `false` | if ServiceMonitor should be deployed |
| mongod.persistence.data.accessModes[0] | string | `"ReadWriteOnce"` |  |
| mongod.persistence.data.size | string | `"5Gi"` |  |
| mongod.persistence.data.storageClassName | string | `""` |  |
| mongod.persistence.logs.accessModes[0] | string | `"ReadWriteOnce"` |  |
| mongod.persistence.logs.size | string | `"1Gi"` |  |
| mongod.persistence.logs.storageClassName | string | `""` |  |
| mongod.resources.limits.cpu | string | `"100m"` |  |
| mongod.resources.limits.memory | string | `"128Mi"` |  |
| mongod.resources.requests.cpu | string | `"100m"` |  |
| mongod.resources.requests.memory | string | `"128Mi"` |  |
| mongod.tls.caConfigMapRef.name | string | `"tls-ca-configmap-name"` |  |
| mongod.tls.certificateKeySecretRef.name | string | `"tls-secret-name"` |  |
| mongod.tls.enabled | bool | `false` | Enable TLS for MongoDB communication |
| mongod.type | string | `"ReplicaSet"` | MongoDB setup type |
| mongodb_agent.resources.limits.cpu | string | `"100m"` |  |
| mongodb_agent.resources.limits.memory | string | `"128Mi"` |  |
| mongodb_agent.resources.requests.cpu | string | `"100m"` |  |
| mongodb_agent.resources.requests.memory | string | `"128Mi"` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| replicaCount | int | `1` | MongoDB instances count |
| serviceAccount.nameOverride | string | `""` | should match database.name from operator chart |
| tolerations | list | `[]` |  |
| users | list | `[]` |  |
| version | string | `""` | MongoDB version (defaults to appVersion) |

