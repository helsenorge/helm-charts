{{/*
Navn på løsningsområde
*/}}
{{- define "area.name" -}}
{{- .Values.global.area | default .Values.area }}
{{- end }}

{{/*
Navn på ansvarlig team
*/}}
{{- define "area.team" -}}
{{- .Values.global.team | default .Values.team | lower | trunc 63 | }}
{{- end }}

{{/*
Versjon av applikasjon
*/}}
{{- define "releaseVersion" -}}
{{- .Chart.AppVersion | default "latest" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Helsenorge config prefix. Prefix used before any helsenorge environment variable
*/}}
{{- define "configPrefix" -}}
{{- .Values.global.configPrefix | default .Values.configPrefix }}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "labels" -}}
helm.sh/chart: {{ include "chart" . }}
app.kubernetes.io/managed-by: {{ "ehelse-common" }}
app.kubernetes.io/part-of: {{ include "area.name" . }}
app.kubernetes.io/created-by: {{ include "area.team" . }}
app.kubernetes.io/version: {{ include "releaseVersion" . | quote }}
area: {{ include "area.name" . }}
team: {{ include "area.team" . }}
version: {{ include "releaseVersion" . | quote }}
{{- end }}

{{/*
Name of ehelse-common config-maps
*/}}
{{- define "distributedPersistentCache.ConfigMapName" -}}
{{ printf "%s-%s" ( include "area.name" . ) "distributed-persistant-cache" | lower  }}
{{- end -}}

{{- define "fellesloggClientSettings.ConfigMapName" -}}
{{ printf "%s-%s" ( include "area.name" . ) "felleslogg-client" | lower  }}
{{- end -}}

{{- define "ehelseSecurityTokenServiceSettings.ConfigMapName" -}}
{{ printf "%s-%s" ( include "area.name" . ) "ehelse-security-tokenservice-settings" | lower  }}
{{- end -}}

{{- define "sotApiClient.ConfigMapName" -}}
{{ printf "%s-%s" ( include "area.name" . ) "sot-api-client" | lower  }}
{{- end -}}

{{- define "tokenValidationSettings.ConfigMapName" -}}
{{ printf "%s-%s" ( include "area.name" . ) "token-validation-settings" | lower  }}
{{- end -}}

{{- define "internalMessagingSettings.ConfigMapName" -}}
{{ printf "%s-%s" ( include "area.name" . ) "internal-messaging-settings" | lower  }}
{{- end -}}

{{- define "configurationFileShare.ConfigMapName" -}}
{{ printf "%s-%s" ( include "area.name" . ) "configuration-files-share" | lower  }}
{{- end -}}

{{- define "loggingConfiguration.ConfigMapName" -}}
{{ printf "%s-%s" ( include "area.name" . ) "logging-configuration" | lower  }}
{{- end -}}

{{/*
  Mount shared ehelse.config
*/}}
{{ define "ehelse-common.MountConfig" }}
- configMapRef:
    name: {{ include "distributedPersistentCache.ConfigMapName" . }}
- configMapRef:
    name: {{ include "fellesloggClientSettings.ConfigMapName" . }}
- configMapRef:
    name: {{ include "ehelseSecurityTokenServiceSettings.ConfigMapName" . }}
- configMapRef:
    name: {{ include "sotApiClient.ConfigMapName" . }}
- configMapRef:
    name: {{ include "tokenValidationSettings.ConfigMapName" . }}
- configMapRef:
    name: {{ include "internalMessagingSettings.ConfigMapName" . }}
- configMapRef:
    name: {{ include "configurationFileShare.ConfigMapName" . }}
- configMapRef:
    name: {{ include "loggingConfiguration.ConfigMapName" . }}
{{- end -}}