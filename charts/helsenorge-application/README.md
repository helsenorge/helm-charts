# helsenorge-applikasjon

![Version: 0.0.13](https://img.shields.io/badge/Version-0.0.13-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

Helm chart for som beskriver hvordan deployment av en helsenorge-applikasjon ser ut. En helsenorge-applikasjon dekker typene api, webapp og service.

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Team Plattform | utv-hn-plattform@norskhelsenett.slack.com | https://www.nhn.no/ |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| aspnetCoreEnvironment | string | `"k8s"` | setter ASPNETCORE_ENVIRONMENT environment-variabelen i pod |
| clientId | string | `""` | Id registrert i STS-vertikalen for applikasjonen |
| clientSecret | string | `""` | Tilhærende secret til klienten |
| configurationEndpoint | string | `"http://configuration-internalapi"` | Endepunkt til configuration-vertikalen sitt internalapi - Blir tilgjengeliggjort som environment-variabler i pod |
| debug.configShare | string | `"/config-share/"` | path i pod der debug-dll blir tilgjengeligjort |
| debug.debugConfigMap | string | `"debug-environment"` | navn på config-map som inneholder debug-dll. Denne må eksistere i miljøet fra før |
| debug.enabled | bool | `false` | skrur på debug-modus i miljøet. Krever at debug.dll config-map er tilgjengelig i miljøet. |
| dnsZone | string | `"aks-helsenorge.utvikling"` | Dns-sonen til miljøet. |
| extraEnvVariables | string | `nil` | Environment variabler som tilgjengeliggjøres podden - Brukes for å overstyre config-settings Skrives på formen key: value Husk å bruke prefix HN_ for at environment-variabelen skal leses inn av config-systemet Eks:  HN_ConfigurationSettings_Connectionstring: "Server=sql;Database=databaename;User Id=user;Password=password;" |
| fellesloggEndpoint | string | `"http://felleslogg-internalapi"` | Endepunkt til felleslog-vertikalen sitt internal api - Blir tilgjengeliggjort som environment-variabler i pod |
| fullnameOverride | string | `""` | Overrider navn på chart.  |
| image | object | Se verdier under | Beskriver imaget til applikasjonen |
| image.args | string | `""` | Argumenter til commanden. Beskrives som et array. |
| image.command | string | `"/app/container-startup.sh"` | Kommandoen som skal kjøre inne i imaget ved oppstart.  Dette kan være pathen til et bash-script, kjoring av en executable eller annet. Bestemmes av hvordan container-imaget er bygget. Ler mer om entrypoint [her](https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/). |
| image.pullPolicy | string | `"IfNotPresent"` | Kubernetes image pull-policy. Les mer om image pull policy [her](https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy). |
| image.registry | string | `"helsenorge.azurecr.io"` | Fra hvilket container registry skal imaget hentes.  |
| image.repository | string | `""` | Navn på imaget som skal deployes. Hvis ikke definert, settes til det samme som navnet på applikasjonen. TODO: gjøre det mulig å overstyre repository |
| image.tag | string | `""` | tag identifiserer versjonen på imaget som skal deployes  |
| imagePullSecrets | list | `[]` | Referanse til secret som inneholder nøkler for å få kontakt med private container registry (hvis dette er i bruk) |
| ingress | object | Se verdier under | Beskriver hvordan komponenten skal eksponeres ut av clustert, slik at komponenten kan konsumeres av ressurser utenfor clusteret.  Les mer [her](https://kubernetes.io/docs/concepts/services-networking/ingress/). |
| ingress.create | bool | `true` | Bestemmer om en ingress skal opprettes eller ikke, false betyr at ingen ingress opprettes og komponenten kan ikke nås utenfra clusteret. |
| ingress.hostname | string | kalkuleres basert på apinavn og miljo | Bestemmer hvilket hostname ingress skal lytte på. Eks configuration-internalapi-mas01.helsenorge.utvikling. Trenger ikke overstyres med mindre man skal teste noe spesielt |
| livenessProbe.path | string | `"/api/ping"` | [Liveness probe](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#types-of-probe) indikerer om containeren kjører ved å gjøre et http kall mot gitt path. |
| logging | object | `{"areaOvveride":"","logLevel":"info"}` | Logging |
| nameOverride | string | `""` | Overrider navn på chart. Beholder release-navnet |
| rabbitmq | object | `{"amqpPort":5671,"configPassword":"","configUser":"","encryptMessages":true,"hostname":"rabbitmq","password":"","symmetricKey":"","useSsl":true,"user":"","virtualHost":"internal.messaging.helsenorge.no"}` | Messagings settings - Blir tilgjengeliggjort som environment-variabler i pod |
| rabbitmq.amqpPort | int | `5671` | amqp-port |
| rabbitmq.configPassword | string | `""` | Configbruker passord |
| rabbitmq.configUser | string | `""` | Configbruker  |
| rabbitmq.encryptMessages | bool | `true` | Skru på meldingskryptering |
| rabbitmq.hostname | string | `"rabbitmq"` | Hostname til rabbitmq |
| rabbitmq.password | string | `""` | Passord |
| rabbitmq.symmetricKey | string | `""` | Krypteringsnøkkel for meldinger hvis kryptering er skrudd på |
| rabbitmq.useSsl | bool | `true` | Amqp trafikk over ssl |
| rabbitmq.user | string | `""` | Bruker |
| readinessProbe.path | string | `"/health"` | [Readiness probe](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#types-of-probe) indikerer om containeren er klar for å motta requests ved å gjøre et http kall mot gitt path |
| redis | object | `{"areaEncryptionKey":"","configuration":"redis-persistence-master:6379","globalEncryptionKey":""}` | Cache settings - Blir tilgjengeliggjort som environment-variabler i pod |
| redis.areaEncryptionKey | string | `""` | krypteringsnøkkel for cache verdier innenfor området/applikasjon |
| redis.configuration | string | `"redis-persistence-master:6379"` | eks: redis1:6379,redis2:6379 |
| redis.globalEncryptionKey | string | `""` | krypteringsnøkkel for globale cache verdier |
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
| sotEndpoint | string | `"http://sot-internalapi"` | Endepunkt til sot-vertikalen sitt internalapi - Blir tilgjengeliggjort som environment-variabler i pod |
| splunk | object | `{"sourceType":"kube:Helsenorge"}` | Splunk |
| splunk.sourceType | string | `"kube:Helsenorge"` | Setter SourceType på loggene i splunk |
| team | string | `""` | Ansvarlig team for losningsomraade - eks "Plattform".  |
| tokenValidation | object | `{"hashingSecret":"","signingCertificateThumbprint":""}` | Tokenvalidering - Blir tilgjengeliggjort som environment-variabler i pod |
| tokenValidation.hashingSecret | string | `""` | TODO hva er dette? |
| tokenValidation.signingCertificateThumbprint | string | `""` | Thumbprint til valideringssertifikat - public del av sikkerhets-sertifikat |
| tokenserviceEndpoint | string | `"http://sts-tokenservice"` | Endepunkt til sts-vertikalen sin tokenservice - Blir tilgjengeliggjort som environment-variabler i pod |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.6.0](https://github.com/norwoodj/helm-docs/releases/v1.6.0)
