{{/*
Overrider area i logg hvis satt.
*/}}
{{- define "logging.area" }}
{{- if .Values.logging.areaOvveride }}
{{- .Values.logging.areaOvveride }}
{{- else }}
{{- .Release.Name }}
{{- end }}
{{- end }}


