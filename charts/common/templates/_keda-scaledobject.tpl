{{- define "common.keda-scaledobject.tpl" -}}
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: {{ include "common.fullname" . }}
spec:
  minReplicaCount: {{ .Values.keda.minReplicaCount }}
  maxReplicaCount: {{ .Values.keda.maxReplicaCount }}
  pollingInterval: {{ .Values.keda.pollingInterval | default 30 }}
  cooldownPeriod: {{ .Values.keda.cooldownPeriod | default 300 }}
  scaleTargetRef:
    name: {{ include "common.fullname" . }}
  {{- if .Values.keda.fallback }}
  fallback:
  {{- toYaml .Values.keda.fallback | nindent 4 }}
  {{- end }}
  {{- if .Values.keda.advanced }}
  advanced:
  {{- toYaml .Values.keda.advanced | nindent 4 }}
  {{- end }}
  triggers:
    {{- if .Values.keda.triggers }}
    {{- toYaml .Values.keda.triggers | nindent 4 }}
    {{- end }}
{{- end }}
