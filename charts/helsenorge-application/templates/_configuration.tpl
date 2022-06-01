{{/*
LoggingConfiguration
*/}}
{{- define "LoggingConfiguration" }}
- name: {{  printf "%s%s" (include "configPrefix" .)  "LoggingConfiguration__Area" }}
  value: {{ .Values.applicationConfig.loggingConfiguration.area | quote | default (include "area.name" .) }}
- name: {{  printf "%s%s" (include "configPrefix" .)  "LoggingConfiguration__Level" }}
  value: {{ .Values.applicationConfig.loggingConfiguration.logLevel | quote | default "info" }}
{{- end }}

{{/*
InternalMessagingSettings
*/}}
{{- define "InternalMessagingSettings" }}
{{- $fellesConfigMapName := "felles-config-internalmessaging"  }}
{{- $fellesConfigSecretName := "felles-config-secret-internalmessaging" }}
- name: {{ printf "%s%s" (include "configPrefix" .)  "InternalMessagingSettings__RootAddress" }}
  valueFrom:
    configMapKeyRef:
      name: {{ $fellesConfigMapName }}
      key: rabbitEndpoint
- name: {{ printf "%s%s" (include "configPrefix" .)  "InternalMessagingSettings__VirtualHost" }}
  valueFrom:
    configMapKeyRef:
      name: {{ $fellesConfigMapName }}
      key: virtualHost
- name: {{ printf "%s%s" (include "configPrefix" .)  "InternalMessagingSettings__UseSsl" }}
  valueFrom:
    configMapKeyRef:
      name: {{ $fellesConfigMapName }}
      key: useSsl
- name: {{ printf "%s%s" (include "configPrefix" .)  "InternalMessagingSettings__EncryptMessages" }}
  valueFrom:
    configMapKeyRef:
      name: {{ $fellesConfigMapName }}
      key: encryptMessages
- name: {{ printf "%s%s" (include "configPrefix" .)  "InternalMessagingSettings__ConfigurationCredentials__Username" }}
  valueFrom:
    secretKeyRef:
      name: {{ $fellesConfigSecretName }}
      key: configUsername
- name: {{ printf "%s%s" (include "configPrefix" .)  "InternalMessagingSettings__ConfigurationCredentials__Password" }}
  valueFrom:
    secretKeyRef:
      name: {{ $fellesConfigSecretName }}
      key: configPassword
- name: {{ printf "%s%s" (include "configPrefix" .)  "InternalMessagingSettings__Credentials__Username" }}
  value: {{ .Values.applicationConfig.internalMessaging.username | quote }}
- name: {{ printf "%s%s" (include "configPrefix" .)  "InternalMessagingSettings__Credentials__Password" }}
  value: {{ .Values.applicationSecrets.internalMessaging.password | quote }}
{{- end -}}

{{/*
ClientSettings
*/}}
{{- define "ClientSettings" }}
- name: {{  printf "%s%s" (include "configPrefix" .)  "EhelseSecurityTokenServiceSettings__ClientId" }}
  value: {{ .Values.applicationConfig.clientSettings.clientId | quote | default (include "area.name" .) }}
- name: {{  printf "%s%s" (include "configPrefix" .)  "EhelseSecurityTokenServiceSettings__ClientSecret" }}
  value: {{ .Values.applicationSecrets.clientSettings.clientSecret | quote }}
{{- end -}}

{{/*
ConfigurationFileShare
*/}}
{{- define "ConfigurationFileShare" }}
- name: {{  printf "%s%s" (include "configPrefix" .)  "ConfigurationFileShare__Share" }}
  value: {{ .Values.applicationConfig.configurationFileShare.share | quote | default "/config-share/" }}
{{- end -}}
