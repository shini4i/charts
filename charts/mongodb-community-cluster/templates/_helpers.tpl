{{/*
Expand the name of the chart.
*/}}
{{- define "mongodb-community-cluster.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mongodb-community-cluster.fullname" -}}
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
{{- define "mongodb-community-cluster.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mongodb-community-cluster.labels" -}}
helm.sh/chart: {{ include "mongodb-community-cluster.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
mongodb/version: {{ .Values.version | default .Chart.AppVersion }}
{{- end }}

{{/*
Create the name of the service account to use
Currently defaults to "mongodb-database" as it is hardcoded in MongoDB operator
*/}}
{{- define "mongodb-community-cluster.serviceAccountName" -}}
{{ default "mongodb-database" .Values.serviceAccount.nameOverride }}
{{- end }}

{{- define "mongodb-users" }}
{{- if .Values.users }}
{{- range $key, $value := .Values.users -}}
- name: {{ $value.name }}
  db: {{ $value.db }}
  {{- if $value.roles }}
  roles:
  {{- range $k, $v := $value.roles }}
    - db: {{ $v.db }}
      name: {{ $v.name }}
  {{- end }}
  {{- end }}
  passwordSecretRef:
    name: {{ $value.name }}-user-password
  scramCredentialsSecretName: {{ $value.name }}
  connectionStringSecretName: {{ $value.name }}-connection-string
{{ end -}}
{{ else }}
{{- "[]" }}
{{ end }}
{{- end }}

{{- define "hook-script" -}}
{{- range $key, $value := .Values.users -}}
kubectl get secret {{ $value.name }}-user-password || kubectl create secret generic {{ $value.name }}-user-password --from-literal=password={{ randAlphaNum 32 }}
{{ end }}
{{- if .Values.metrics.enabled -}}
kubectl get secret {{ include "mongodb-community-cluster.fullname" . }}-prometheus-credentials || kubectl create secret generic {{ include "mongodb-community-cluster.fullname" . }}-prometheus-credentials --from-literal=username=prometheus --from-literal=password={{ randAlphaNum 32 }}
{{ end }}
{{- end -}}

{{- define "mongodb-hosts" }}
{{- $name := .Release.Name }}
{{- $namespace := .Release.Namespace }}
{{- $count := sub .Values.replicaCount 1 }}
{{- range $i := until (.Values.replicaCount | int) -}}
{{ $name }}-{{ . }}.{{ $name }}-svc.{{ $namespace }}.svc.cluster.local{{ if ne $i $count }},{{ end }}
{{- end }}
{{- end }}
