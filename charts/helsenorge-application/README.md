# helsenorge-applikasjon

![Version: 0.0.12](https://img.shields.io/badge/Version-0.0.12-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

Helm chart for som beskriver hvordan deployment av en helsenorge-applikasjon ser ut. En helsenorge-applikasjon dekker typene api, webapp og service.

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Team Plattform | utv-hn-plattform@norskhelsenett.slack.com | https://www.nhn.no/ |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| TokenValidationSettings | object | Se verdier under | Fellesconfig for Tokenvalidering |
| TokenValidationSettings.Metadata.ConfigMapName | string | `"tokenvalidation-config"` | Navn på config-map som opprettes. |
| TokenValidationSettings.SigningCertificate | string | `"F46ECB29F8B9994D2286B073C1CEA6A52BB746FC"` | Thumbprint til valideringssertifikat |
| TokenValidationSettings.TokenHashingSecret | string | `"fdafdaszxcdards534534534432r5423sdfaczx23r"` | Hashingsecret |
| area | string | `""` | Navn på losningsomraadet applikasjonen tilhører - eks "personvern". |
| debugEnvironment | bool | `true` |  |
| dnsZone | string | `"aks-helsenorge.utvikling"` | Dns-sonen til miljøet. Overstyres i høyere miljøer. |
| envVariables | string | `nil` | Environment variabler som tilgjengeliggjøres for løsningsområde Skrives på formen key: value |
| helsenorgeSikkerhetCertificate | object | `{"certificate":{"name":"helsenorge-sikkerhet","secretName":"certificate.helsenorge-sikkerhet"},"mount":false,"mountPath":"helsenorge-sikkerhet-private"}` | Helsenorge sikkerhetssertikat |
| helsenorgeSikkerhetCertificate.certificate.name | string | `"helsenorge-sikkerhet"` | Navn på sertifikat |
| helsenorgeSikkerhetCertificate.certificate.secretName | string | `"certificate.helsenorge-sikkerhet"` | Navn på secret sertifikat hentes fra |
| helsenorgeSikkerhetCertificate.mount | bool | `false` | Skal sertifikatet mountes på containerne |
| helsenorgeSikkerhetCertificate.mountPath | string | `"helsenorge-sikkerhet-private"` | Hvor på containerne skal sertifikatet mountes |
| image | object | Se verdier under | Beskriver imaget til applikasjonen |
| image.args | string | `nil` | Argumenter til commanden. Beskrives som et array. |
| image.command | string | `"/app/container-startup.sh"` | Kommandoen som skal kjøre inne i imaget ved oppstart.  Dette kan være pathen til et bash-script, kjoring av en executable eller annet. Bestemmes av hvordan container-imaget er bygget. Ler mer om entrypoint [her](https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/). |
| image.pullPolicy | string | `"IfNotPresent"` | Kubernetes image pull-policy. Les mer om image pull policy [her](https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy). |
| image.registry | string | `"helsenorge.azurecr.io"` | Fra hvilket container registry skal imaget hentes.  |
| image.repository | string | `""` | Navn på imaget som skal deployes. Hvis ikke definert, settes til det samme som navnet på applikasjonen. TODO: gjøre det mulig å overstyre repository |
| image.tag | string | `nil` | tag identifiserer versjonen på imaget som skal deployes  |
| imagePullSecrets | list | `[]` | Referanse til secret som inneholder nøkler for å få kontakt med private container registry (hvis dette er i bruk) |
| ingress | object | Se verdier under | Beskriver hvordan komponenten skal eksponeres ut av clustert, slik at komponenten kan konsumeres av ressurser utenfor clusteret.  Les mer [her](https://kubernetes.io/docs/concepts/services-networking/ingress/). |
| ingress.create | bool | `true` | Bestemmer om en ingress skal opprettes eller ikke, false betyr at ingen ingress opprettes og komponenten kan ikke nås utenfra clusteret. |
| ingress.hostname | string | kalkuleres basert på apinavn og miljo | Bestemmer hvilket hostname ingress skal lytte på. Eks configuration-internalapi-mas01.helsenorge.utvikling. Trenger ikke overstyres med mindre man skal teste noe spesielt |
| livenessProbe.path | string | `"/api/ping"` | [Liveness probe](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#types-of-probe) indikerer om containeren kjører ved å gjøre et http kall mot gitt path. |
| name | string | `""` | Navn på applikasjonen som skal deployes. Kombineres med area.name, så du trenger ikke inkludere navn på losningsomraadet i navnet.  |
| readinessProbe.path | string | `"/health"` | [Readiness probe](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#types-of-probe) indikerer om containeren er klar for å motta requests ved å gjøre et http kall mot gitt path |
| replicaCount | int | `2` | Antall containere som kjører apiet. Disse lastbalanseres automatisk, men flere containere krever mer ressurser av clusteret. Bør overstyrers i høyere miljøer. |
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
| splunk | object | `{"sourceType":"kube:Helsenorge"}` | Setter visse parametere for hvordan applikasjonenslogger sendes til splunk |
| splunk.sourceType | string | `"kube:Helsenorge"` | Setter SourceType for applikasjonen |
| team | string | `""` | Ansvarlig team for losningsomraade - eks "Plattform".  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.6.0](https://github.com/norwoodj/helm-docs/releases/v1.6.0)
