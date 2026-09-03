{{/*
Expand the name of the chart.
*/}}
{{- define "app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "app.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "app.labels" -}}
helm.sh/chart: {{ include "app.chart" . }}
{{ include "app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Renders a complete tree, even values that contains template.
*/}}
{{- define "app.render" -}}
  {{- if typeIs "string" .value }}
    {{- tpl .value .context }}
  {{ else }}
    {{- tpl (.value | toYaml) .context }}
  {{- end }}
{{- end -}}

{{/*
Name for a resource that carries a suffix. The chart name is truncated first so
the result stays within 63 characters, the limit Kubernetes enforces on Job
names and on label values.
*/}}
{{- define "app.suffixedName" -}}
{{- $max := int (sub 62 (len .suffix)) -}}
{{- printf "%s-%s" (include "app.fullname" .context | trunc $max | trimSuffix "-") .suffix -}}
{{- end -}}

{{/*
Pod template labels: the common labels plus app.podLabels. The selector labels
win the merge, because the pod selector is immutable once the workload exists.
*/}}
{{- define "app.podLabels" -}}
{{- $selector := include "app.selectorLabels" . | fromYaml -}}
{{- $common := include "app.labels" . | fromYaml -}}
{{- toYaml (merge $selector $common (.Values.app.podLabels | default dict)) -}}
{{- end -}}

{{/*
Service that backs a StatefulSet. Stable per-pod DNS needs a headless service,
but spec.serviceName is immutable, so the ClusterIP service stays the default
and the headless one is opt-in.
*/}}
{{- define "app.statefulSetServiceName" -}}
{{- if .Values.app.statefulSet.headless.enabled -}}
{{- include "app.suffixedName" (dict "context" . "suffix" "headless") -}}
{{- else -}}
{{- include "app.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Rejects value combinations that the API server would reject with a far less
readable error, or would accept while silently doing nothing. Included from
app.yaml, which renders for every release.
*/}}
{{- define "app.validateValues" -}}
{{- if empty .Values.service.ports -}}
{{- fail "service.ports requires at least one entry" -}}
{{- end -}}
{{- if not (has .Values.service.type (list "NodePort" "LoadBalancer")) -}}
{{- range .Values.service.ports -}}
{{- if .nodePort -}}
{{- fail (printf "service.ports[].nodePort needs service.type NodePort or LoadBalancer, set on port: %s" .name) -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- if not (has .Values.app.kind (list "Deployment" "StatefulSet")) -}}
{{- fail (printf "app.kind must be either Deployment or StatefulSet, got: %s" .Values.app.kind) -}}
{{- end -}}
{{- if and .Values.autoscaling.enabled .Values.keda.enabled -}}
{{- fail "autoscaling.enabled and keda.enabled are mutually exclusive, disable one of them" -}}
{{- end -}}
{{- if and .Values.autoscaling.enabled (empty .Values.autoscaling.targetCPUUtilizationPercentage) (empty .Values.autoscaling.targetMemoryUtilizationPercentage) -}}
{{- fail "autoscaling.enabled requires targetCPUUtilizationPercentage or targetMemoryUtilizationPercentage" -}}
{{- end -}}
{{- if and .Values.keda.enabled (empty .Values.keda.triggers) -}}
{{- fail "keda.enabled requires at least one entry in keda.triggers" -}}
{{- end -}}
{{- if and .Values.podMonitor.enabled (empty .Values.podMonitor.podMetricsEndpoints) -}}
{{- fail "podMonitor.enabled requires at least one entry in podMonitor.podMetricsEndpoints" -}}
{{- end -}}
{{- if .Values.podDisruptionBudget.enabled -}}
{{- $hasMin := not (kindIs "invalid" .Values.podDisruptionBudget.minAvailable) -}}
{{- $hasMax := not (kindIs "invalid" .Values.podDisruptionBudget.maxUnavailable) -}}
{{- if eq $hasMin $hasMax -}}
{{- fail "podDisruptionBudget requires exactly one of minAvailable or maxUnavailable" -}}
{{- end -}}
{{- end -}}
{{- if and (eq .Values.app.kind "StatefulSet") .Values.app.statefulSet.persistence.enabled -}}
{{- range .Values.app.statefulSet.persistence.volumes -}}
{{- if not .size -}}
{{- fail (printf "app.statefulSet.persistence.volumes[].size is required, missing on volume: %s" .name) -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
