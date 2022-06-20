
# helsenorge-applikasjon

Helm chart for installere en helsenorge-applikasjon på kubernetes. En helsenorge-applikasjon dekker typene API, WebApp, Service, Batch. Dvs, applikasjoner som utfører arbeid kontinuerlig.

![Version: 0.0.32](https://img.shields.io/badge/Version-0.0.32-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

## Installasjon

Dette chartet er ment for å inkluderes i et [umbrella chart](https://helm.sh/docs/howto/charts_tips_and_tricks/#complex-charts-with-many-dependencies) for å deploye et helsenorge-løsningsområde, men kan også installeres enkeltvis. Les mer om dette her.

For å installere chartet med navnet "my-release"
```console
$ helm repo add helsenorge http://helsenorge.github.io/helm-charts
$ helm install my-release helsenorge/helsenorge-applikasjon
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| args | list | `[]` | Ovveride default container args - Les mer om Command and Arguments for kontainere [her](https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/). Les mer under ```command```. |
| certificateStore | string | `"root/.dotnet/corefx/cryptography/x509stores/my"` | Path til certificate-store som sertifikater installeres til ved bruk av [certificate tool](https://github.com/gsoft-inc/dotnet-certificate-tool). Fallback plassering for [CurrentUser\My](https://docs.microsoft.com/nb-no/dotnet/standard/security/cross-platform-cryptography#the-my-store) på linux.  |
| clientId | string | `""` | ClientId for applikasjonen |
| clientSecret | string | `""` | Tilhørende secret |
| command | list | `[]` | Ovveride default container command - defaulter til "dotnet" - Les mer om Command and Arguments for kontainere [her](https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/). Eks for å kjøre en dotnet applikasjon ```dotnet myassembly.dll``` bruk command: ``` command: ["dotnet"] ``` og args ``` args: ["myassembly.dll"] ``` |
| debug | object | {} | Debugmodus - Settings for debugmodus |
| debug.configShare | string | `"/config-share/"` | Path til hvor debug-fil mountes i pod'en. |
| debug.debugConfigMap | string | `"debug-environment"` | Navn på config-map som inneholder debug-dll. Denne må eksistere i namespace fra før. |
| dnsZone | string | `"aks-helsenorge.utvikling"` | Dns-sonen til miljøet. |
| enableTokenValidation | bool | `true` | Muligjor tokenvalidering i applikasjonen ved å tilgjengeliggjøre sertifikatet i podden. |
| extraEnvVars | list | `[]` | List av environment variabler som tilgjengeliggjøres podden - Brukes for å overstyre config-settings Skrives på formen key: value Husk å bruke prefix HN_ for at environment-variabelen skal leses inn av config-systemet ```HN_ConfigurationSettings_Connectionstring: "Server=sql;Database=databasename;User Id=user;Password=password;"``` Kan også overstyres globalt: ```global:   extraEnvVars:     HN_ConfigurationSettings_Connectionstring: "Server=sql;Database=databasename;User Id=user;Password=password;"``` |
| extraEnvVarsCM | list | `[]` |  |
| extraEnvVarsSecret | list | `[]` | Navn på eksisterende secret som inneholder extra env-vars. Må skrives på yaml-formen for et gyldig envFrom secret referanse.  |
| extraVolumeMounts | list | `[]` | Liste over extra volume mounts som skal mountes til podden. Må skrives på yaml-formen for et gyldig volume mount. |
| extraVolumes | list | `[]` | Liste over extra volumes som skal tilgjengeliggjøres til deploymenten. Må skrives på yaml-formen for et gyldig volume. |
| fullnameOverride | string | `""` | Overrider navn på chart.  |
| helsenorgeUtilImage | string | `"helsenorge.azurecr.io/utils/certificate-tool:0.1"` | Image som inneholder diverse utils. Benyttes for installasjon av sertifikater. |
| image | object | {} | Beskriver imaget til applikasjonen |
| image.pullPolicy | string | `"IfNotPresent"` | Kubernetes image pull-policy. Les mer om image pull policy [her](https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy). |
| image.registry | string | `"helsenorge.azurecr.io"` | Fra hvilket container registry skal imaget hentes.  |
| image.repository | string | `""` | Navn på imaget som skal deployes. Hvis ikke definert, settes til det samme som navnet på applikasjonen basert på releaename-applikasjonsnavn, eg configuration-internalapi. |
| image.tag | string | `""` | tag identifiserer versjonen på imaget som skal deployes  |
| imagePullSecrets | list | `[]` | Referanse til secret som inneholder nøkler for å få kontakt med private container registry (hvis dette er i bruk) |
| ingress | object | Se verdier under | Beskriver hvordan komponenten skal eksponeres ut av clustert, slik at komponenten kan konsumeres av ressurser utenfor clusteret.  Les mer [her](https://kubernetes.io/docs/concepts/services-networking/ingress/). |
| ingress.create | bool | `true` | Bestemmer om en ingress skal opprettes eller ikke, false betyr at ingen ingress opprettes og komponenten kan ikke nås utenfra clusteret. |
| ingress.hostname | string | kalkuleres basert på apinavn og miljo | Bestemmer hvilket hostname ingress skal lytte på. Eks configuration-internalapi-mas01.helsenorge.utvikling. Trenger ikke overstyres med mindre man skal teste noe spesielt |
| isDebugEnvironment | bool | `false` | Debugmodus - Skrur på debug-modus i miljøet. Krever at debug.dll config-map er tilgjengelig i miljøet. |
| livenessProbe.path | string | `"/api/ping"` | [Liveness probe](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#types-of-probe) indikerer om containeren kjører ved å gjøre et http kall mot gitt path. |
| logging.areaOvveride | string | `""` |  |
| logging.sourceType | string | `"kube:Helsenorge"` | Setter SourceType på loggene i splunk |
| nameOverride | string | `""` | Overrider navn på chart. Beholder release-navnet |
| rabbitmq | object | {...} | Rabbitmq-settings |
| rabbitmq.clusterName | string | `"rabbitmq"` | Navn på cluster, brukes til å sette opp adressen til rabbitmq, så må være det samme som hostnavnet |
| rabbitmq.createUser | bool | `true` | Hvis 'true' så opprettes det en rabbitmq-bruker for applikasjonene. Fungerer kun i miljøer der rabbitmq styres av [rabbitmq-topology-operator](https://www.rabbitmq.com/kubernetes/operator/using-topology-operator.html#non-operator).  Hvis satt til false så må 'user' og 'password' settes. |
| rabbitmq.encryptMessages | bool | `true` | Skal meldinger som går mellom client og rabbitmq krypteres |
| rabbitmq.password | string | `""` | Passord - Brukes kun hvis generate user er satt til 'false' |
| rabbitmq.port | int | `5671` | Port til amqp-endepunktet til rabbitmq |
| rabbitmq.useSsl | bool | `true` | Kommunikasjon mellom client og rabbitmq går over ssl |
| rabbitmq.user | string | `""` | Bruker - Kun angi hvis du ønsker å overskrive at brukernavn blir satt til det samme som applikasjonsnavnet Eks: configuration-internalapi |
| rabbitmq.virtualHost | string | `"internal.messaging.helsenorge.no"` | Navn på virtual host |
| readinessProbe.path | string | `"/health"` | [Readiness probe](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#types-of-probe) indikerer om containeren er klar for å motta requests ved å gjøre et http kall mot gitt path |
| replicaCount | int | `1` | Antall containere som kjører apiet. Disse lastbalanseres automatisk, men flere containere krever mer ressurser av clusteret. Bør overstyrers i høyere miljøer. |
| resources | object | {} | Beskriver hvor mye ressurser en pod som kjører koden skal få tilgang til. Les mer om konseptene [her](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#requests-and-limits). |
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
| team | string | `""` | Ansvarlig team for losningsomraade - eks "Plattform". - Kan overstyres globalt global:   team: "" |
| tokenValidation | object | {} | Informasjon om tokenvalideringssertifikatet i miljoet. |
| tokenValidation.filename | string | `"helsenorge_sikkerhet_public.pem"` | Navn på filen som inneholder sertifikatet |
| tokenValidation.secretName | string | `"certificate.helsenorge-sikkerhet.public"` | Navn på secret som inneholder sertifikatet.  Denne må eksistere i namespace fra før. |
| tokenValidation.volumeMount | string | `"/tokevalidation-cert"` | Path til hvor sertifikatet mountes i pod'en |
| useSharedConfig | bool | `true` | Gir pod'en tilgang til felles-config allerede definert i namespacet. Dette er typisk config som kreves av felles-pakkene. |

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Plattform |  |  |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://helsenorge.github.io/helm-charts/ | helsenorge-common | ~0.0.1 |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.6.0](https://github.com/norwoodj/helm-docs/releases/v1.6.0)