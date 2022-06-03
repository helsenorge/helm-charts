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

