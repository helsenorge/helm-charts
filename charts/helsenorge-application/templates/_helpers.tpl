{{/*
Navn på ansvarlig team
*/}}
{{- define "helsenorge-application.team" -}}
{{- .Values.team | default .Values.global.team | lower | trunc 63 | }}
{{- end }}

{{/*
Versjon av applikasjon
*/}}
{{- define "helsenorge-application.version" -}}
{{- .Values.image.tag | default "latest" }}
{{- end }}

{{/*
Applikasjons image
*/}}
{{- define "helsenorge-application.image" -}}
{{ printf "%s/%s:%s" .Values.image.registry (include "helsenorge-application.fullname" .) (include "helsenorge-application.version" .) }} 
{{- end }}

{{/*
Expand the name of the chart.
*/}}
{{- define "helsenorge-application.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "helsenorge-application.fullname" -}}
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
{{- define "helsenorge-application.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "helsenorge-application.labels" -}}
helm.sh/chart: {{ include "helsenorge-application.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service | lower }}
app.kubernetes.io/part-of: {{ .Release.Name | lower }}
app.kubernetes.io/created-by: {{ include "helsenorge-application.team" . }}
app.kubernetes.io/version: {{ include "helsenorge-application.version" . | quote }}
name: {{ include "helsenorge-application.fullname" . }}
area: {{ .Release.Name | lower }}
team: {{ include "helsenorge-application.team" . }}
version: {{ include "helsenorge-application.version" . | quote }}
{{ include "helsenorge-application.selectorLabels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "helsenorge-application.selectorLabels" -}}
app.kubernetes.io/name: {{ include "helsenorge-application.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "helsenorge-application.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "helsenorge-application.fullname" .) .Values.serviceAccount.name | lower}}
{{- else }}
{{- default "default" .Values.serviceAccount.name | lower }}
{{- end }}
{{- end }}

{{/*
ingress hostname
*/}}
{{- define "helsenorge-application.hostname" -}}
{{ default (printf "%s-%s.%s" (include "helsenorge-application.fullname" .) .Release.Namespace .Values.dnsZone) .Values.ingress.hostname }}
{{- end }}


{{/*
Mount av public-delen av helsenorge-sikkerhets-sert: TODO fikse opp i.
*/}}
{{ define "helpers.SikkerSone.PublicCert.Volume" }}
- name: helsenorge-sikkerhet-public
  secret: 
    secretName: certificate.helsenorge-sikkerhet.public
{{- end -}}

{{ define "helpers.SikkerSone.PublicCert.VolumeMount" }}
- name: helsenorge-sikkerhet-public
  mountPath: /certificates/helsenorge-sikkerhet-public" 
  readOnly: true
{{- end -}}


{{/*
List environment variables
*/}}
{{- define "helpers.list-env-variables"}}
{{- range $key, $val := .Values.extraEnvVariables }}
- name: {{ $key }}
  value: {{ $val | quote }}
{{- end }}
{{- range $key, $val := .Values.global.sharedEnvVariables }}
- name: {{ $key }}
  value: {{ $val | quote }}
{{- end }}
{{- end }}

