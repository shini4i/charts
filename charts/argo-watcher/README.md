# argo-watcher

![Version: 1.2.3](https://img.shields.io/badge/Version-1.2.3-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v1.0.0](https://img.shields.io/badge/AppVersion-v1.0.0-informational?style=flat-square)

A Helm chart for deploying argo-watcher

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Vadim Gedz | <github@shini4i.dev> | <https://github.com/shini4i> |

## Source Code

* <https://github.com/shini4i/argo-watcher>
* <https://github.com/shini4i/argo-watcher-mcp>
* <https://github.com/shini4i/charts/tree/main/charts/argo-watcher>

## Requirements

Kubernetes: `>=1.21.0-0`

## Quick start

```console
helm repo add shini4i https://shini4i.github.io/charts/
helm repo update
helm install argo-watcher shini4i/argo-watcher -f values.yaml
```

The chart deploys the argo-watcher server as a StatefulSet. The REST API your CI
client talks to and the Web UI are served on the same port, so one Ingress
covers both:

```yaml
argo:
  url: https://argocd.argocd.svc.cluster.local
  secretName: argo-watcher
ingress:
  enabled: true
  hosts:
    - host: argo-watcher.example.com
      paths:
        - path: /
          pathType: ImplementationSpecific
```

Point the CI client (`ghcr.io/shini4i/argo-watcher-client`) at that host through
`ARGO_WATCHER_URL`; the upstream [installation guide](https://argo-watcher.readthedocs.io/en/latest/guides/install/)
has GitLab CI and GitHub Actions examples.

`networkPolicies.enabled: true` denies ingress to the pods and then allows the
release namespace back in, so an Ingress in front of it needs a
`networkPolicies.additionalRules` entry for the controller's own namespace.

### The Argo CD secret

The chart creates no secrets. Create one yourself and name it in
`argo.secretName` — it is mounted with `envFrom`, so every key in it becomes an
environment variable:

| Key | Purpose |
|-----|---------|
| `ARGO_TOKEN` | Argo CD API token. Required; the server refuses to start without it. |
| `ARGO_WATCHER_DEPLOY_TOKEN` | Shared token the CI client presents. Optional, planned for deprecation upstream. |
| `JWT_SECRET` | HMAC key for signing client JWTs — the recommended alternative to the deploy token. |

A dedicated Argo CD account with `get` and `sync` on `applications */*` is
enough for the token:

```console
argocd account generate-token --account watcher
```

## State backend

`postgres.enabled: false`, the default, keeps task history in the process. It is
single-replica only — the chart refuses to render with `replicaCount > 1` — and
the history, along with any manually set deploy lock, is lost on every restart.

For a persistent, multi-replica install, point the chart at an existing
PostgreSQL database:

```yaml
postgres:
  enabled: true
  host: postgres.example.svc.cluster.local
  name: argo-watcher
  user: argo-watcher
  secretName: argo-watcher-postgres
```

The secret is consumed like the Argo CD one: with `postgres.secretKey` unset the
whole secret is loaded through `envFrom` and must contain `DB_PASSWORD`; set
`postgres.secretKey` to map a differently named key onto it instead.

Migrations need no manual step. The chart schedules a `pre-install`/`pre-upgrade`
hook Job that runs `argo-watcher --migrate` with the same image and database
credentials, so `helm upgrade` applies new migrations before the new pods start.

## GitOps updater

Setting `updater.sshSecretName` enables argo-watcher's built-in image tag
updater, which commits to your GitOps repository instead of relying on Argo CD
Image Updater. It needs three things:

- A secret holding the private SSH key under `updater.sshKey` (`sshPrivateKey`
  by default), authorised to write to the GitOps repository.
- A client credential — `ARGO_WATCHER_DEPLOY_TOKEN` or `JWT_SECRET` in the Argo
  CD secret above. Tasks submitted without one are still tracked, but never
  trigger a write-back.
- Annotations on the Argo CD Application that say which images to update and
  where to write the tag; see the upstream
  [GitOps updater guide](https://argo-watcher.readthedocs.io/en/latest/guides/gitops-updater/).

Known hosts for GitHub, GitLab, Bitbucket and Azure DevOps ship with the chart.
`updater.extraKnownHosts` appends to them; `updater.knownHostsConfigMap`
replaces them with a ConfigMap of your own.

The persistent volume backs the updater's git clone cache (`REPO_CACHE_PATH`,
default `/data`). `persistence.mountPath` moves the mount but not the cache
path, so if you change it, set `REPO_CACHE_PATH` through `extraEnvs` to match.
With the updater unused, `persistence.enabled: false` swaps the volume for a
tmpfs `emptyDir`.

## Authentication and the deploy lock

The `oidc.*` values map onto the server's `OIDC_*` variables; `issuerUrl` and
`clientId` are required when `oidc.enabled` is true and the chart fails the
render without them. Enabling OIDC closes the reads the Web UI consumes
(`/api/v1/tasks`, `/version`, `/reachability`, `GET /deploy-lock`); the
endpoints the CI client uses stay open, so no pipeline breaks.

Three settings on the provider decide whether it works:

- **Redirect URI** — the application's base URL, including the trailing slash.
  A mismatch fails the login on the provider's own error page.
- **Web origin** — the application's origin, so the browser's cross-origin
  userinfo request is allowed. Keycloak has a separate **Web origins** field.
- **`groups` claim** — emitted in the userinfo response under a scope
  argo-watcher requests (`profile` or `email`).

The last two fail quietly: sign-in succeeds while the redeploy button and
deploy-lock toggle stay hidden. The upstream
[OIDC guide](https://argo-watcher.readthedocs.io/en/latest/guides/oidc/) covers
all three per provider.

`oidc.tokenValidationInterval` defaults to 10 s here, against the server's own
5 min. That is one userinfo call per token per interval, so raise it if your
provider is remote or rate-limited.

Recurring maintenance windows are set with `scheduledLockdown` and need no
authentication. Locking deployments manually from the Web UI does require OIDC:
without an auth backend the server never registers the lock endpoints.

## MCP server

Setting `mcp.enabled: true` deploys [argo-watcher-mcp](https://github.com/shini4i/argo-watcher-mcp),
which exposes argo-watcher's read-only API as [Model Context Protocol](https://modelcontextprotocol.io)
tools so AI agents can ask what was deployed, when, by whom, and whether it
succeeded. Upstream describes the project as a proof of concept.

It runs as its own Deployment, not a sidecar, so its image and configuration
change without restarting argo-watcher. `mcp.image.tag` is pinned independently
of the chart `appVersion`, which tracks argo-watcher itself. The
`get_reachability` tool needs argo-watcher v0.13.0 or newer.

> [!IMPORTANT]
> **The MCP server does not work with `oidc.enabled: true`.** As of argo-watcher
> v0.15.0 the reads its tools depend on require a credential when OIDC is on,
> and argo-watcher-mcp v0.3.0 sends none — every tool gets a 401.

### Exposing the MCP server

> [!WARNING]
> **argo-watcher-mcp performs no authentication and no authorization.** Every
> request is anonymous, there is no token support and no per-tool permission
> model. Anything that can reach the endpoint can read every deployment's
> application, image tags, author, timestamp and outcome, the deploy-lock state,
> and an allowlisted subset of the instance configuration.

The server cannot create deployments or change the deploy lock, so the exposure
is disclosure and request load, not tampering. It strips `user:password@`
credentials from URL-valued config fields, but forwards `ARGO_URL_ALIAS` and
`DOCKER_IMAGES_PROXY` as argo-watcher reports them.

**Port-forward — nothing is exposed.** Enough for a developer workstation and
the recommended default:

```console
kubectl --namespace <namespace> port-forward svc/<release>-argo-watcher-mcp 8000:80
```

Then point the MCP client at `http://localhost:8000`.

**In-cluster only.** An agent running in another namespace reaches the endpoint
without any Ingress. With `networkPolicies.enabled: true`, grant that namespace
access explicitly:

```yaml
networkPolicies:
  enabled: true
mcp:
  enabled: true
  networkPolicies:
    additionalRules:
      - namespaceSelector:
          matchLabels:
            kubernetes.io/metadata.name: my-agent-namespace
```

`mcp.networkPolicies.additionalRules` is deliberately separate from
`networkPolicies.additionalRules`, and the MCP pods carry their own
`app.kubernetes.io/name` label, so widening access to the MCP endpoint cannot
also widen access to the argo-watcher API.

**Ingress, behind an authenticating proxy.** Since the endpoint authenticates
nobody, the proxy in front of it is the only access control. Terminate
authentication there — for example with
[oauth2-proxy](https://oauth2-proxy.github.io/oauth2-proxy/) or your ingress
controller's external-auth support:

```yaml
mcp:
  enabled: true
  ingress:
    enabled: true
    className: nginx
    annotations:
      nginx.ingress.kubernetes.io/auth-url: "https://oauth2-proxy.example.com/oauth2/auth"
      nginx.ingress.kubernetes.io/auth-signin: "https://oauth2-proxy.example.com/oauth2/start?rd=$escaped_request_uri"
    hosts:
      - host: argo-watcher-mcp.example.com
        paths:
          - path: /
            pathType: Prefix
    tls:
      - secretName: argo-watcher-mcp-tls
        hosts:
          - argo-watcher-mcp.example.com
```

With `networkPolicies.enabled: true`, the ingress controller also needs an
`mcp.networkPolicies.additionalRules` entry for its own namespace. Without one
the deny-by-default policy drops its traffic and the Ingress returns 502 with
nothing pointing at the NetworkPolicy as the cause.

Two transport details to check against your proxy: the MCP endpoint is mounted
at `/`, so it cannot share a host with another backend without a path prefix,
and its streamable transport holds a long-lived server-sent-events stream open,
which a proxy that buffers responses or applies a short read timeout will break.

### Metrics

The MCP server serves Prometheus metrics on `/metrics` on the same port as the
MCP endpoint itself. Set `mcp.podMonitor.enabled: true` to scrape it.
OpenTelemetry export is configured through `mcp.extraEnvs` using the upstream
`OTEL_*` variables.

Because the two share a port, a NetworkPolicy rule that lets a monitoring
namespace scrape `/metrics` also lets it call every MCP tool. The argo-watcher
PodMonitor has the same property.

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
| livenessProbe | object | `{"enabled":true,"failureThreshold":3,"initialDelaySeconds":5,"path":"/livez","periodSeconds":30,"timeoutSeconds":5}` | Liveness probe configuration. /livez checks no dependency. |
| logLevel | string | `"info"` |  |
| mcp.affinity | object | `{}` |  |
| mcp.enabled | bool | `false` | Deploy the MCP server alongside argo-watcher |
| mcp.extraEnvs | list | `[]` | Additional environment variables for the MCP container, e.g. the OTEL_* settings (supports both value and valueFrom) |
| mcp.image.pullPolicy | string | `"IfNotPresent"` |  |
| mcp.image.repository | string | `"ghcr.io/shini4i/argo-watcher-mcp"` |  |
| mcp.image.tag | string | `"v0.3.0"` | MCP server image tag. Pinned here rather than derived from the chart appVersion, which tracks argo-watcher itself. Required when mcp is enabled. |
| mcp.ingress.annotations | object | `{}` |  |
| mcp.ingress.className | string | `""` |  |
| mcp.ingress.enabled | bool | `false` | Expose the MCP endpoint via Ingress. Anything that can reach it can read the full deployment history and instance configuration, so put an authenticating proxy in front — see "Exposing the MCP server" in the README. |
| mcp.ingress.hosts[0].host | string | `"chart-example.local"` |  |
| mcp.ingress.hosts[0].paths[0].path | string | `"/"` |  |
| mcp.ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| mcp.ingress.tls | list | `[]` |  |
| mcp.livenessProbe | object | `{"enabled":true,"failureThreshold":3,"initialDelaySeconds":5,"path":"/healthz","periodSeconds":30,"timeoutSeconds":5}` | Liveness probe configuration. /healthz reports only whether the MCP process is up; it does not depend on argo-watcher. |
| mcp.networkPolicies.additionalRules | list | `[]` | Additional ingress rules granting access to the MCP container port. Created when networkPolicies.enabled is true; kept separate from networkPolicies.additionalRules so opening the MCP endpoint to a wider audience cannot also open the argo-watcher API. |
| mcp.nodeSelector | object | `{}` |  |
| mcp.podAnnotations | object | `{}` |  |
| mcp.podMonitor.enabled | bool | `false` |  |
| mcp.podMonitor.labels | object | `{}` |  |
| mcp.podSecurityContext | object | `{}` |  |
| mcp.readinessProbe | object | `{"enabled":true,"failureThreshold":3,"initialDelaySeconds":3,"path":"/healthz","periodSeconds":10,"timeoutSeconds":3}` | Readiness probe configuration. /healthz keeps the server serving while argo-watcher is down, so its get_reachability tool can report the outage; /readyz gates readiness on argo-watcher instead, and drops out with it. |
| mcp.replicaCount | int | `1` |  |
| mcp.requestTimeout | string | `"15s"` | How long the MCP server waits for an argo-watcher API response |
| mcp.resources | object | `{}` |  |
| mcp.revisionHistory | int | `1` |  |
| mcp.securityContext.allowPrivilegeEscalation | bool | `false` |  |
| mcp.securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| mcp.securityContext.readOnlyRootFilesystem | bool | `true` |  |
| mcp.securityContext.runAsNonRoot | bool | `true` |  |
| mcp.securityContext.runAsUser | int | `65532` |  |
| mcp.securityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| mcp.service.containerPort | int | `8000` |  |
| mcp.service.port | int | `80` |  |
| mcp.service.type | string | `"ClusterIP"` |  |
| mcp.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| mcp.serviceAccount.automountServiceAccountToken | bool | `false` | Whether to automount the service account token. The MCP server never calls the Kubernetes API. |
| mcp.serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| mcp.serviceAccount.name | string | `""` | The name of the service account to use. Required when create is false. |
| mcp.tolerations | list | `[]` |  |
| mcp.topologySpreadConstraints | list | `[]` |  |
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
| oidc | object | `{"clientId":"","enabled":false,"gravatarFallback":false,"issuerUrl":"","privilegedGroups":[],"tokenValidationInterval":10000}` | OIDC / SSO authentication configuration. Requires argo-watcher >= v0.13.0; earlier versions only honor the deprecated KEYCLOAK_* variables, which can be set via extraEnvs. |
| oidc.clientId | string | `""` | Client ID registered with the identity provider (required when enabled) |
| oidc.enabled | bool | `false` | Enables OIDC authentication for the Web UI and privileged operations |
| oidc.gravatarFallback | bool | `false` | Falls back to Gravatar when the provider sends no picture claim; discloses the user's email address to gravatar.com |
| oidc.issuerUrl | string | `""` | Identity provider issuer URL used for OIDC discovery, e.g. https://keycloak.example.com/realms/example (required when enabled) |
| oidc.privilegedGroups | list | `[]` | Groups whose members may redeploy applications and manage the deployment lock |
| oidc.tokenValidationInterval | int | `10000` | Interval in milliseconds between token validations |
| persistence.accessModes | list | `["ReadWriteOnce"]` | The access modes for the persistent volume claim |
| persistence.annotations | object | `{}` | Annotations to add to the persistent volume claim |
| persistence.emptyDirSizeLimit | string | `"256Mi"` | Size limit for emptyDir volume used when persistence is disabled (tmpfs) |
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
| readinessProbe | object | `{"enabled":true,"failureThreshold":3,"initialDelaySeconds":3,"path":"/readyz","periodSeconds":10,"timeoutSeconds":3}` | Readiness probe configuration. /readyz reports down while the pod is shutting down and while the state backend is unreachable; ArgoCD reachability is excluded. |
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
| startupProbe | object | `{"enabled":false,"failureThreshold":30,"path":"/livez","periodSeconds":5,"timeoutSeconds":3}` | Startup probe configuration. Disabled: argo-watcher binds its listener only after initialisation and exits rather than starting degraded, so there is no slow-start window to cover. |
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
