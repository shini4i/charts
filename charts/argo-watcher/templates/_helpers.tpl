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

The suffix is appended after truncating the base to 59 characters, not before:
truncating the joined string would collapse any 63-character name back onto the
argo-watcher name, silently giving both workloads the same selector labels. The
one input this does not separate is a 63-character name that already ends in
"-mcp".
*/}}
{{- define "argo-watcher.mcp.name" -}}
{{- printf "%s-mcp" (include "argo-watcher.name" . | trunc 59 | trimSuffix "-") }}
{{- end }}

{{- define "argo-watcher.mcp.fullname" -}}
{{- printf "%s-mcp" (include "argo-watcher.fullname" . | trunc 59 | trimSuffix "-") }}
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
