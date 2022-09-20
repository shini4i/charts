{{- define "common.podmonitor.tpl" -}}
apiVersion: monitoring.coreos.com/v1
kind: PodMonitor
metadata:
  name: {{ include "common.fullname" . }}-metrics
  {{- with .Values.podMonitor.labels }}
  labels:
  {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  selector:
    matchLabels:
  {{- include "common.selectorLabels" . | nindent 6 }}
  podMetricsEndpoints:
    {{- toYaml .Values.podMonitor.podMetricsEndpoints | nindent 4 }}
{{- end -}}
