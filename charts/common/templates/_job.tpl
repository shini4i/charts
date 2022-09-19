{{- define "common.job.yaml" -}}
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ include "common.fullname" . }}-job
  {{- if .Values.job.annotations }}
  annotations:
    {{ toYaml .Values.job.annotations }}
  {{- end }}
spec:
  template:
    spec:
      containers:
        - name: job
          image: {{ .Values.job.image.repository }}:{{ .Values.job.image.tag }}
          command:
            {{- range .Values.job.command }}
            - {{ . | quote }}
            {{- end }}
          {{- if .Values.job.env }}
          env:
          {{- toYaml .Values.job.env | nindent 10 }}
          {{- end }}
          {{- if .Values.job.envFrom }}
          envFrom:
          {{- toYaml .Values.job.envFrom | nindent 10 }}
          {{- end }}
      restartPolicy: {{ .Values.job.restartPolicy }}
  backoffLimit: {{ .Values.job.backoffLimit }}
{{- end -}}
