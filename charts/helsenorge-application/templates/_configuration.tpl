{{/*
InternalMessagingSettings
*/}}
{{- define "Felles-InternalMessagingSettings" }}
{{- $fellesConfigMapName := "felles-config-internalmessaging"  }}
{{- $fellesConfigSecretName := "felles-config-secret-internalmessaging" }}

- name: {{ printf "%s%s" .Values.configPrefix "InternalMessagingSettings__RootAddress" }}
  valueFrom:
    configMapKeyRef:
      name: {{ $fellesConfigMapName }}
      key: rabbitEndpoint
- name: {{ printf "%s%s" .Values.configPrefix "InternalMessagingSettings__VirtualHost" }}
  valueFrom:
    configMapKeyRef:
      name: {{ $fellesConfigMapName }}
      key: virtualHost
- name: {{ printf "%s%s" .Values.configPrefix "InternalMessagingSettings__UseSsl" }} 
  valueFrom:
    configMapKeyRef:
      name: {{ $fellesConfigMapName }}
      key: useSsl
- name: {{ printf "%s%s" .Values.configPrefix "InternalMessagingSettings__EncryptMessages" }}
  valueFrom:
    configMapKeyRef:
      name: {{ $fellesConfigMapName }}
      key: encryptMessages
- name: {{ printf "%s%s" .Values.configPrefix "InternalMessagingSettings__ConfigurationCredentials__Username" }}
  valueFrom:
    secretKeyRef:
      name: {{ $fellesConfigSecretName }}
      key: configUsername
- name: {{ printf "%s%s" .Values.configPrefix "InternalMessagingSettings__ConfigurationCredentials__Password" }}
  valueFrom:
    secretKeyRef:
      name: {{ $fellesConfigSecretName }}
      key: configPassword
{{- end -}}



