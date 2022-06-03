{{/*
Navn på løsningsområde
*/}}
{{- define "area.name" -}}
{{- .Values.area | default .Values.global.area }}
{{- end }}

{{/*
Navn på ansvarlig team
*/}}
{{- define "area.team" -}}
{{- .Values.team | default .Values.global.team | lower | trunc 63 | }}
{{- end }}

{{/*
Navn på applikasjon
*/}}
{{- define "application.name" -}}
{{- .Release.Name | lower | trunc 63 }}
{{- end }}

{{/*
Versjon av applikasjon
*/}}
{{- define "application.version" -}}
{{- .Values.image.tag | default "latest" }}
{{- end }}

{{/*
Applikasjons image
*/}}
{{- define "application.image" -}}
{{ printf "%s/%s:%s" .Values.image.registry (include "application.fullName" .) (include "application.version" .) }} 
{{- end }}

{{/*
Navn på applikasjon. Kombinasjon av løsningsområde og applikasjonsnavn.
*/}}
{{- define "application.fullName" -}}
{{- if contains ( include "area.name" . ) (include "application.name" . ) -}}
{{- include "application.name" . }}
{{- else }}
{{- printf "%s-%s" ( include "area.name" . ) .Values.name | lower  }}
{{- end }}
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
app.kubernetes.io/part-of: {{ include "area.name" . }}
app.kubernetes.io/created-by: {{ include "area.team" . }}
app.kubernetes.io/version: {{ include "application.version" . | quote }}
name: {{ include "application.name" . }}
area: {{ include "area.name" . }}
team: {{ include "area.team" . }}
version: {{ include "application.version" . | quote }}
{{ include "helsenorge-application.selectorLabels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "helsenorge-application.selectorLabels" -}}
app.kubernetes.io/name: {{ include "application.fullName" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "helsenorge-application.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "application.fullName" .) .Values.serviceAccount.name | lower}}
{{- else }}
{{- default "default" .Values.serviceAccount.name | lower }}
{{- end }}
{{- end }}

{{/*
ingress hostname
*/}}
{{- define "helsenorge-application.hostname" -}}
{{ default (printf "%s-%s.%s" (include "application.fullName" .) .Release.Namespace .Values.dnsZone) .Values.ingress.hostname }}
{{- end }}

{{/*
Helsenorge config prefix. Prefix used before any helsenorge environment variable
*/}}
{{- define "configPrefix" -}}
{{- .Values.global.configPrefix | default .Values.configPrefix }}
{{- end -}}


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
  Mount av Debug-dll
*/}}

{{ define "helpers.DebugEnvironment.Volume" }}
{{- if .Values.debugEnvironment }}
- name: debug-environment
  configMap: 
    name: debug-environment
{{- end -}}
{{- end -}}

{{ define "helpers.DebugEnvironment.VolumeMount" }}
{{- if .Values.debugEnvironment }}
- name: debug-environment
  mountPath: /config-share/
  readOnly: true
{{- end }}
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

{{/*
List applikasjons-config

Funksjonen converter en yaml struktur til environment-variabler på formen som Configuration i ASP.NET Core anbefaler.
Det legges på en prefix på nøklene. Dette er prefixen satt i ehelse-common for å skille ut Helsenorge variabler fra standard variabler

https://docs.microsoft.com/en-us/aspnet/core/fundamentals/configuration/?view=aspnetcore-6.0#environment-variables

Funksjonen tar inn en liste over argumenter:
0 = prefixverdien
1 = nøkkelen i yamlstrukturen
2 = verdien til nøkkelen

Hvis verdien er av typen "map", så itererer vi over denne. 
  Hvis nøkkelen har en verdi så kaller vi funksjonen rekursivt der 
  0 = prefixverdi
  1 = nøkkel__nestenøkkel (Eks LoggingConfiguration__Directory)
  2 = verdien til nestenøkkel
  Hvis nøkkelen ikke har en verdi så kaller vi funksjonen rekursivt der
  0 = prefixverdi
  1 = nøkkel
  2 = verdien til nøkkelen
Hvis verdien er av typen "slice", så iterer vi over denne og kaller funksjonen rekursivt der
  0 = prefixverdi
  1 = nøkkel__index (LoggingConfiguration__Directory__0)
  2) verdien til nøkkelen
Hvis verdien ikke er av typen "map" eller "slice" så skriver vi ut verdien på nøkkel og verdi i templaten
*/}}

{{- define "helpers.list-config" -}}
  {{- $value := index . 2 -}}
  {{- if $value -}}
    {{- template "convertFromYamlToDotNetEnv" . -}}
  {{- end -}}
{{- end }}

{{- define "convertFromYamlToDotNetEnv" }}
{{- $prefix := index . 0 -}}
{{- $key := index . 1 -}}
{{- $value := index . 2 -}}
{{- if kindIs "map" $value -}}
  {{- range $k, $v := $value -}}
    {{- if $key -}}
        {{- template "convertFromYamlToDotNetEnv" (list $prefix (printf "%s__%s" $key $k) $v) -}}
    {{- else -}}   
        {{- template "convertFromYamlToDotNetEnv" (list $prefix (printf "%s" $k) $v) -}}
    {{- end -}}          
  {{- end -}}
{{- else if kindIs "slice" $value -}}
  {{- range $k, $v := $value -}}
    {{- template "convertFromYamlToDotNetEnv" (list $prefix (printf "%s__%v" $key $k) $v) -}}
  {{- end -}}
{{- else }}
- name: {{ printf "%s%s" $prefix $key }}
  value: {{  $value | quote }}
{{- end -}}
{{- end -}}
