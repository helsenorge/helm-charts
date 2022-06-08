{{/*
Navn på ansvarlig team
*/}}
{{- define "common.team" -}}
{{- .Values.team | default .Values.global.team | lower | trunc 63 | }}
{{- end }}

{{/*
Versjon av applikasjon
*/}}
{{- define "common.version" -}}
{{- .Values.image.tag | default "latest" }}
{{- end }}

{{/*
Applikasjons image
*/}}
{{- define "common.image" -}}
{{ printf "%s/%s:%s" .Values.image.registry (include "common.fullname" .) (include "common.version" .) }} 
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
app.kubernetes.io/version: {{ include "common.version" . | quote }}
name: {{ include "common.fullname" . }}
area: {{ .Release.Name | lower }}
team: {{ include "common.team" . }}
version: {{ include "common.version" . | quote }}
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
