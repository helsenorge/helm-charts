{{/*
GET rabbitmq.RootAdress
*/}}
{{- define "rabbitmq.rootAddress" }}
{{- printf "rabbitmq://%s:%v" .Values.rabbitmq.hostname .Values.rabbitmq.amqpPort -}}
{{- end }}

{{/*
SET Logging.Area
*/}}
{{- define "logging.area" }}
{{- if .Values.logging.areaOvveride }}
{{- .Values.logging.areaOvveride }}
{{- else }}
{{- .Release.Name }}
{{- end }}
{{- end }}

{{/*
  Enable debug-mode
*/}}
{{ define "debug.volume" }}
{{- if .Values.debug.enabled }}
- name: debug-environment
  configMap: 
    name: {{ .Values.debug.debugConfigMap }}
{{- end -}}
{{- end -}}

{{ define "debug.volumeMount" }}
{{- if .Values.debug.enabled }}
- name: debug-environment
  mountPath: {{ .Values.debug.configShare }}
  readOnly: true
{{- end }}
{{- end -}}

