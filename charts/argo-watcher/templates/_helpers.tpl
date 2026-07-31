{{/*
Expand the name of the chart.
*/}}
{{- define "argo-watcher.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "argo-watcher.fullname" -}}
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
{{- define "argo-watcher.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "argo-watcher.labels" -}}
helm.sh/chart: {{ include "argo-watcher.chart" . }}
{{ include "argo-watcher.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "argo-watcher.selectorLabels" -}}
app.kubernetes.io/name: {{ include "argo-watcher.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "argo-watcher.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "argo-watcher.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Name of the MCP server workload. Kept distinct from the argo-watcher name so the
argo-watcher selectors, NetworkPolicies and PodMonitor never match MCP pods.

Truncation happens before the suffix is appended, and the result is compared
against the base rather than length-checked: a base of 62 or 63 characters that
already ends in "-mcp" reduces back to itself, which would hand both workloads
the same selector labels.
*/}}
{{- define "argo-watcher.mcp.name" -}}
{{- $base := include "argo-watcher.name" . }}
{{- $name := printf "%s-mcp" ($base | trunc 59 | trimSuffix "-") }}
{{- if eq $name $base }}
{{- fail (printf "nameOverride %q yields an MCP workload name identical to argo-watcher's; shorten it to at most 61 characters or drop its \"-mcp\" suffix" $base) }}
{{- end }}
{{- $name }}
{{- end }}

{{- define "argo-watcher.mcp.fullname" -}}
{{- $base := include "argo-watcher.fullname" . }}
{{- $name := printf "%s-mcp" ($base | trunc 59 | trimSuffix "-") }}
{{- if eq $name $base }}
{{- fail (printf "fullname %q yields an MCP object name identical to argo-watcher's; shorten the release name, nameOverride or fullnameOverride to at most 61 characters" $base) }}
{{- end }}
{{- $name }}
{{- end }}

{{/*
Resolved MCP server image tag. The chart appVersion tracks argo-watcher, so the
MCP image has no appVersion to fall back on.
*/}}
{{- define "argo-watcher.mcp.tag" -}}
{{- if not .Values.mcp.image.tag }}
{{- fail "mcp.image.tag is required when mcp.enabled is true; the chart appVersion tracks argo-watcher, not the MCP server" }}
{{- end }}
{{- .Values.mcp.image.tag }}
{{- end }}

{{- define "argo-watcher.mcp.selectorLabels" -}}
app.kubernetes.io/name: {{ include "argo-watcher.mcp.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "argo-watcher.mcp.labels" -}}
helm.sh/chart: {{ include "argo-watcher.chart" . }}
{{ include "argo-watcher.mcp.selectorLabels" . }}
app.kubernetes.io/version: {{ include "argo-watcher.mcp.tag" . | trunc 63 | trimSuffix "-" | quote }}
app.kubernetes.io/component: mcp
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
In-cluster URL of the argo-watcher API the MCP server reads from.
*/}}
{{- define "argo-watcher.mcp.upstreamUrl" -}}
{{- printf "http://%s:%v" (include "argo-watcher.fullname" .) .Values.service.port }}
{{- end }}

{{- define "argo-watcher.mcp.serviceAccountName" -}}
{{- if .Values.mcp.serviceAccount.create }}
{{- default (include "argo-watcher.mcp.fullname" .) .Values.mcp.serviceAccount.name }}
{{- else }}
{{- required "mcp.serviceAccount.name is required when mcp.serviceAccount.create is false" .Values.mcp.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "argo-watcher.scheduleToString" -}}
{{- $scheduleList := .Values.scheduledLockdown -}}
{{- $finalString := "" -}}
{{- range $index, $value := $scheduleList }}
    {{- if $index }}
        {{- $finalString = print $finalString "," $value -}}
    {{- else }}
        {{- $finalString = print $value -}}
    {{- end }}
{{- end }}
{{- print $finalString -}}
{{- end }}
