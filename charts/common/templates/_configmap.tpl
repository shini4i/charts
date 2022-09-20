{{- define "common.configmap.tpl" -}}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "common.configmapName" . }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
data:
{{- range $key, $value := .Values.configMap.data }}
  {{ $key }}: {{ $value | quote }}
{{- end }}
{{- end -}}
