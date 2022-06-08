{{/*
ingress hostname
*/}}
{{- define "helsenorge-application.hostname" -}}
{{ default (printf "%s-%s.%s" (include "common.fullname" .) .Release.Namespace .Values.dnsZone) .Values.ingress.hostname }}
{{- end }}



