# helsenorge-applikasjon

![Version: 0.0.20](https://img.shields.io/badge/Version-0.0.20-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

Helm chart for som beskriver hvordan deployment av en helsenorge-applikasjon ser ut. En helsenorge-applikasjon dekker typene api, webapp og service.

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Team Plattform | utv-hn-plattform@norskhelsenett.slack.com | https://www.nhn.no/ |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| file://../helsenorge-common | helsenorge-common | ~0.0.1 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| args | string | `nil` | Ovveride default container args - Les mer om Command and Arguments for kontainere [her](https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/). |
| aspnetCoreEnvironment | string | `"k8s"` | setter ASPNETCORE_ENVIRONMENT environment-variabelen i pod |
| clientId | string | `""` | ClientId for applikasjonen |
| clientSecret | string | `""` | Tilhørende secret |
| command | string | `nil` | Ovveride default container command - defaulter til "dotnet" - Les mer om Command and Arguments for kontainere [her](https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/). |
| debug.configShare | string | `"/config-share/"` | path i pod der debug-dll blir tilgjengeligjort |
| debug.debugConfigMap | string | `"debug-environment"` | navn på config-map som inneholder debug-dll. Denne må eksistere i namespace fra før |
| debug.enabled | bool | `false` | skrur på debug-modus i miljøet. Krever at debug.dll config-map er tilgjengelig i miljøet. |
| dnsZone | string | `"aks-helsenorge.utvikling"` | Dns-sonen til miljøet. |
| extraEnvVars | string | `nil` | Environment variabler som tilgjengeliggjøres podden - Brukes for å overstyre config-settings Skrives på formen key: value Husk å bruke prefix HN_ for at environment-variabelen skal leses inn av config-systemet Eks:  HN_ConfigurationSettings_Connectionstring: "Server=sql;Database=databaename;User Id=user;Password=password;" |
| extraEnvVarsCM[0].configMapRef.name | string | `"felles-config"` |  |
| extraEnvVarsSecret[0].secretRef.name | string | `"felles-config"` |  |
| extraVolumeMounts[0].mountPath | string | `"/certificates"` |  |
| extraVolumeMounts[0].name | string | `"helsenorge-sikkerhet-public"` |  |
| extraVolumeMounts[0].readOnly | bool | `true` |  |
| extraVolumes[0].name | string | `"helsenorge-sikkerhet-public"` |  |
| extraVolumes[0].secret.secretName | string | `"certificate.helsenorge-sikkerhet.public"` |  |
| fullnameOverride | string | `""` | Overrider navn på chart.  |
| image | object | Se verdier under | Beskriver imaget til applikasjonen |
| image.pullPolicy | string | `"IfNotPresent"` | Kubernetes image pull-policy. Les mer om image pull policy [her](https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy). |
| image.registry | string | `"helsenorge.azurecr.io"` | Fra hvilket container registry skal imaget hentes.  |
| image.repository | string | `""` | Navn på imaget som skal deployes. Hvis ikke definert, settes til det samme som navnet på applikasjonen basert på releaename+applikasjonsnavn, eg configuration-internalapi. TODO: gjøre det mulig å overstyre repository |
| image.tag | string | `""` | tag identifiserer versjonen på imaget som skal deployes  |
| imagePullSecrets | list | `[]` | Referanse til secret som inneholder nøkler for å få kontakt med private container registry (hvis dette er i bruk) |
| ingress | object | Se verdier under | Beskriver hvordan komponenten skal eksponeres ut av clustert, slik at komponenten kan konsumeres av ressurser utenfor clusteret.  Les mer [her](https://kubernetes.io/docs/concepts/services-networking/ingress/). |
| ingress.create | bool | `true` | Bestemmer om en ingress skal opprettes eller ikke, false betyr at ingen ingress opprettes og komponenten kan ikke nås utenfra clusteret. |
| ingress.hostname | string | kalkuleres basert på apinavn og miljo | Bestemmer hvilket hostname ingress skal lytte på. Eks configuration-internalapi-mas01.helsenorge.utvikling. Trenger ikke overstyres med mindre man skal teste noe spesielt |
| livenessProbe.path | string | `"/api/ping"` | [Liveness probe](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#types-of-probe) indikerer om containeren kjører ved å gjøre et http kall mot gitt path. |
| logging | object | `{"areaOvveride":""}` | Logging |
| nameOverride | string | `""` | Overrider navn på chart. Beholder release-navnet |
| rabbitmq | object | `{"password":"","user":""}` | Messagings settings - Blir tilgjengeliggjort som environment-variabler i pod |
| rabbitmq.password | string | `""` | Passord |
| rabbitmq.user | string | `""` | Bruker |
| readinessProbe.path | string | `"/health"` | [Readiness probe](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#types-of-probe) indikerer om containeren er klar for å motta requests ved å gjøre et http kall mot gitt path |
| replicaCount | int | `1` | Antall containere som kjører apiet. Disse lastbalanseres automatisk, men flere containere krever mer ressurser av clusteret. Bør overstyrers i høyere miljøer. |
| resources | object | Se verdier under | Beskriver hvor mye ressurser en pod som kjører koden skal få tilgang til. Les mer om konseptene [her](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#requests-and-limits). |
| resources.limits | object | Se verdier under | Hvor mye ressurser er poden begrenset til. |
| resources.limits.cpu | string | `"200m"` | [Limits and requests for CPU resources are measured in cpu units. One cpu, in Kubernetes, is equivalent to 1 vCPU/Core for cloud providers and 1 hyperthread on bare-metal Intel processors](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-cpu). |
| resources.limits.memory | string | `"128Mi"` | [Limits and requests for memory are measured in bytes.](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-memory). |
| resources.requests | object | Se verdier under | Hvor mye ressurser poden minimum trenger. |
| resources.requests.cpu | string | `"100m"` | Samme som under resources.limits. |
| resources.requests.memory | string | `"128Mi"` | Samme som under resources.limits. |
| service | object | Se verdier under | Servicen som eksponerer apiet ut i klusteret. |
| service.port | int | `80` | Port servicen eksponerer apiet på ut i clusteret. |
| service.type | string | `"ClusterIP"` | Type service. Les mer [her](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). |
| serviceAccount | object | `{"annotations":{},"create":true}` | Kubernetes service-konto for losningsomraade. Les mer [her](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/). Navn settes til det samme som applikasjon. |
| serviceAccount.annotations | object | `{}` | Spesifikke annoteringer som skal legges til servicekontoen (todo). |
| serviceAccount.create | bool | `true` | Spesifiserer om en service-konto skal opprettes. |
| splunk | object | `{"sourceType":"kube:Helsenorge"}` | Splunk |
| splunk.sourceType | string | `"kube:Helsenorge"` | Setter SourceType på loggene i splunk |
| team | string | `""` | Ansvarlig team for losningsomraade - eks "Plattform".  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.6.0](https://github.com/norwoodj/helm-docs/releases/v1.6.0)
