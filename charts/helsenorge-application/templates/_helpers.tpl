{{/*
Setter hostname for applikasjonen i ingressen. 
*/}}
{{- define "helsenorge-application.hostname" -}}
{{ default (printf "%s-%s.%s" (include "common.fullname" .) .Release.Namespace .Values.dnsZone) .Values.ingress.hostname }}
{{- end }}

{{/*
Navn på rabbitmq-user for applikasjon
*/}}
{{- define "helsenorge-application.rabbitmqUser" -}}
{{ .Values.rabbitmq.user | default (include "common.fullname" .)  }}
{{- end }}

{{/*
Navn på rabbitmq-user secret
*/}}
{{- define "helsenorge-application.rabbitmqUserSecret" -}}
{{ printf "%s-%s" (include "common.fullname" .) "rabbitmq-user" }}
{{- end }}



