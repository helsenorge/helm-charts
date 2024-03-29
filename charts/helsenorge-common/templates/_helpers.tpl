{{/*
Navn på ansvarlig team. Henter fra Chart.Maintainers. Kan overstyres globalt eller per chart.
*/}}
{{- define "common.team" -}}
{{- if or .Values.teamOverride .Values.global.teamOverride }} 
{{- .Values.teamOverride | default .Values.global.teamOverride | lower | trunc 63 }}
{{- else }}
{{- with index .Chart.Maintainers 0 }}
{{- .Name | lower | trunc 63 }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Versjon av applikasjon - henter ut tag fra image-string
*/}}
{{- define "common.version" -}}
{{- regexFind "[^:]+$" .Values.image }} 
{{- end }}

{{/*
Expand the name of the chart.
*/}}
{{- define "common.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "common.fullname" -}}
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
{{- define "common.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{/*
Common labels
*/}}
{{- define "common.labels.standard" -}}
helm.sh/chart: {{ include "common.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service | lower }}
app.kubernetes.io/part-of: {{ .Release.Name | lower }}
app.kubernetes.io/created-by: {{ include "common.team" . }}
app.kubernetes.io/version: {{ include "common.version" . }}
{{ include "common.selectorLabels.standard" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "common.selectorLabels.standard" -}}
app.kubernetes.io/name: {{ include "common.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "common.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "common.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Is environment in debug-mode - checks if ovverided globally
*/}}
{{- define "common.isDebugEnvironment" -}}
{{- .Values.isDebugEnvironment | default .Values.global.isDebugEnvironment }}
{{- end }}

{{/*
https://github.com/bitnami/charts/blob/master/bitnami/common/templates/_tplvalues.tpl

Renders a value that contains template.
Usage:
{{ include "common.tplvalues.render" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "common.tplvalues.render" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}
