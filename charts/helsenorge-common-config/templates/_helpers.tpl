{{/*
Navn på løsningsområde
*/}}
{{- define "area.name" -}}
{{- .Values.area.name | lower | trunc 63 | default "" }}
{{- end }}

{{/*
Navn på ansvarlig team
*/}}
{{- define "area.team" -}}
{{- .Values.area.team | lower | trunc 63 | default ""  }}
{{- end }}

{{/*
Versjon av applikasjon
*/}}
{{- define "releaseVersion" -}}
{{- .Chart.Version | default "latest" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "labels" -}}
helm.sh/chart: {{ include "chart" . }}
app.kubernetes.io/managed-by: {{ "Helm" }}
app.kubernetes.io/part-of: {{ include "area.name" . }}
app.kubernetes.io/created-by: {{ include "area.team" . }}
app.kubernetes.io/version: {{ include "releaseVersion" . | quote }}
area: {{ include "area.name" . }}
team: {{ include "area.team" . }}
version: {{ include "releaseVersion" . | quote }}
{{- end }}
