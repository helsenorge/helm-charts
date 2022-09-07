



# helsenorge-applikasjon

Helm chart for installere en helsenorge-applikasjon på kubernetes. En helsenorge-applikasjon dekker typene API, WebApp, Service, Batch. Dvs, applikasjoner som utfører arbeid kontinuerlig.

![Version: 0.0.44](https://img.shields.io/badge/Version-0.0.44-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) 

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
| nameOverride | string | `""` | Overrider navn på chart. Beholder release-navnet |
| fullnameOverride | string | `""` | Overrider navn på chart.  |
| teamOvveride | string | `""` | Hentes fra Chart.Maintainers[0].name (Chart.yaml) - Kan ovverides ved behov, også globalt. |
| enableTokenValidation | bool | `true` | Muligjor tokenvalidering i applikasjonen ved å tilgjengeliggjøre sertifikatet i podden. |
| tokenValidation | object | {} | Informasjon om tokenvalideringssertifikatet i miljoet. |
| tokenValidation.filename | string | `"helsenorge_sikkerhet_public.pem"` | Navn på filen som inneholder sertifikatet |
| tokenValidation.volumeMount | string | `"/tokevalidation-cert"` | Path til hvor sertifikatet mountes i pod'en |
| tokenValidation.secretName | string | `"certificate.helsenorge-sikkerhet.public"` | Navn på secret som inneholder sertifikatet.  Denne må eksistere i namespace fra før. |
| tokenValidation.image | string | `"helsenorge.azurecr.io/utils/certificate-tool:2.0.7"` | Image som brukes som init-container for installasjon av sertifikat |
| tokenValidation.imagePullPolicy | string | `"IfNotPresent"` | Image pull policy for init-container |
| certificateStore | string | `"root/.dotnet/corefx/cryptography/x509stores/my"` | Path til certificate-store som sertifikater installeres til ved bruk av [certificate tool](https://github.com/gsoft-inc/dotnet-certificate-tool). Fallback plassering for [CurrentUser\My](https://docs.microsoft.com/nb-no/dotnet/standard/security/cross-platform-cryptography#the-my-store) på linux.  |
| rabbitmq | object | {...} | Rabbitmq-settings |
| rabbitmq.createUser | bool | `true` | Hvis 'true' så opprettes det en rabbitmq-bruker for applikasjonene. Fungerer kun i miljøer der rabbitmq styres av [rabbitmq-topology-operator](https://www.rabbitmq.com/kubernetes/operator/using-topology-operator.html#non-operator).  Hvis satt til false så må 'user' og 'password' settes. |
| rabbitmq.user | string | `""` | Bruker - Kun angi hvis du ønsker å overskrive at brukernavn blir satt til det samme som applikasjonsnavnet Eks: configuration-internalapi |
| rabbitmq.password | string | `""` | Passord - Brukes kun hvis generate user er satt til 'false' |
| rabbitmq.virtualHost | string | `"internal.messaging.helsenorge.no"` | Navn på virtual host |
| rabbitmq.clusterName | string | `"rabbitmq"` | Navn på cluster, brukes til å sette opp adressen til rabbitmq, så må være det samme som hostnavnet |
| rabbitmq.port | int | `5671` | Port til amqp-endepunktet til rabbitmq |
| rabbitmq.useSsl | bool | `true` | Kommunikasjon mellom client og rabbitmq går over ssl |
| rabbitmq.encryptMessages | bool | `true` | Skal meldinger som går mellom client og rabbitmq krypteres |
| logging.areaOvveride | string | `""` |  |
| logging.sourceType | string | `"kube:Helsenorge"` | Setter SourceType på loggene i splunk |
| dnsZone | string | `"helsenorge.utvikling"` | Dns-sonen til miljøet. |
| image | string | `nil` | Image referanse: registry/repository:tag |
| imagePullPolicy | string | `"Always"` | Pull-policy satt på imaget |
| command | list | `[]` | Ovveride default container command - defaulter til "dotnet" - Les mer om Command and Arguments for kontainere [her](https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/). Eks for å kjøre en dotnet applikasjon ```dotnet myassembly.dll``` bruk command: ``` command: ["dotnet"] ``` og args ``` args: ["myassembly.dll"] ``` |
| args | list | `[]` | Ovveride default container args - Les mer om Command and Arguments for kontainere [her](https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/). Les mer under ```command```. |
| replicaCount | int | `1` | Antall containere som kjører apiet. Disse lastbalanseres automatisk, men flere containere krever mer ressurser av clusteret. Bør overstyrers i høyere miljøer. |
| livenessProbe.path | string | `"/api/ping"` | [Liveness probe](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#types-of-probe) indikerer om containeren kjører ved å gjøre et http kall mot gitt path. |
| readinessProbe.path | string | `"/health"` | [Readiness probe](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#types-of-probe) indikerer om containeren er klar for å motta requests ved å gjøre et http kall mot gitt path |
| serviceAccount | object | `{"annotations":{},"create":true,"imagePullSecrets":["helsenorge-pull-secret"]}` | Kubernetes service-konto. Les mer [her](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/). Navn settes til det samme som applikasjon. |
| serviceAccount.create | bool | `true` | Spesifiserer om en service-konto skal opprettes. |
| serviceAccount.annotations | object | `{}` | Spesifikke annoteringer som skal legges til servicekontoen (todo). |
| serviceAccount.imagePullSecrets | list | `["helsenorge-pull-secret"]` | Legger på egne image pull secrets på service accounten. Gjør det mulig for pods som kjører under denne service-accounten å få tilgang til private registry |
| service | object | Se verdier under | Servicen som eksponerer apiet ut i klusteret. |
| service.type | string | `"ClusterIP"` | Type service. Les mer [her](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). |
| service.port | int | `80` | Port servicen eksponerer apiet på ut i clusteret. |
| service.annotations | object | `{}` | Ingress annoteringer, skrives som key-value par.  |
| ingress | object | Se verdier under | Beskriver hvordan komponenten skal eksponeres ut av clustert, slik at komponenten kan konsumeres av ressurser utenfor clusteret.  Les mer [her](https://kubernetes.io/docs/concepts/services-networking/ingress/). |
| ingress.create | bool | `true` | Bestemmer om en ingress skal opprettes eller ikke, false betyr at ingen ingress opprettes og komponenten kan ikke nås utenfra clusteret. |
| ingress.hostname | string | genereres basert på apinavn og miljo | Bestemmer hvilket hostname ingress skal lytte på. Eks configuration-internalapi-mas01.helsenorge.utvikling. Trenger ikke overstyres med mindre man skal teste noe spesielt |
| ingress.tlsSecret | string | Hvis ikke angitt så brukes default | Spesifiserer navn på secret som inneholder tls-sertifikatet som skal benyttes på endepunktet.  Vil være nødvendig å angi hvis tjenesten skal eksponeres på et annet domene enn standard og eksponeres på port 443, typisk hvis hostname er angitt. |
| ingress.annotations | object | `{}` | Ingress annoteringer, skrives som key-value par.  For en full liste av mulige ingress annoteringer, les [her](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md) |
| ingress.className | string | `"nginx"` | Navnet på implementasjonen av ingress-controlleren som skal benyttes. |
| resources | object | {} | Beskriver hvor mye ressurser en pod som kjører koden skal få tilgang til. Les mer om konseptene [her](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#requests-and-limits). |
| resources.limits | object | Se verdier under | Hvor mye ressurser er poden begrenset til. |
| resources.limits.cpu | string | `"200m"` | [Limits and requests for CPU resources are measured in cpu units. One cpu, in Kubernetes, is equivalent to 1 vCPU/Core for cloud providers and 1 hyperthread on bare-metal Intel processors](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-cpu). |
| resources.limits.memory | string | `"128Mi"` | [Limits and requests for memory are measured in bytes.](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-memory). |
| resources.requests | object | Se verdier under | Hvor mye ressurser poden minimum trenger. |
| resources.requests.cpu | string | `"100m"` | Samme som under resources.limits. |
| resources.requests.memory | string | `"128Mi"` | Samme som under resources.limits. |
| extraEnvVars | object | `{}` | Map av environment variabler som tilgjengeliggjøres for podden. Se [her](env-eksempler) for eksempler. |
| extraEnvVarsCM | list | `[]` | Liste over eksisterende config-maps der innholdet lastes inn i podden som envVars. Se [her](#envfrom-configmap-eksempler) for eksempler.  |
| extraEnvVarsSecret | list | `[]` | Liste over eksisterende secrets der innholdet lastes inn i podden som envVars. Se [her](#envfrom-secret-eksempler) for eksempler. |
| extraVolumes | list | `[]` | Liste over extra volumes som skal tilgjengeliggjøres til deploymenten. Se [her](#volume-og-volumemount-eksempler) for eksempler. |
| extraVolumeMounts | list | `[]` | Liste over extra volume mounts som skal mountes til podden. Se [her](#volume-og-volumemount-eksempler) for eksempler. |
| isDebugEnvironment | bool | `false` | Debugmodus - Skrur på debug-modus i miljøet. Krever at debug.dll config-map er tilgjengelig i miljøet. |
| debug | object | {} | Debugmodus - Settings for debugmodus |
| debug.configShare | string | `"/config-share/"` | Path til hvor debug-fil mountes i pod'en. |
| debug.debugConfigMap | string | `"debug-environment"` | Navn på config-map som inneholder debug-dll. Denne må eksistere i namespace fra før. |
| useSharedConfig | bool | `true` | Gir pod'en tilgang til felles-config allerede tilgjengeligjort i miljoet. Dette er typisk config som kreves av felles-pakkene. |
| hostAliases | list | `[]` | Legger inn hostfil innslag i pod'ens /etc/host. Se [her](#hostalias-eksempler) for eksempler. |

## Eksempler
### Env eksempler
Alle environment-variabler defineres som et ```key: value``` par. Disse kan defineres per applikasjon eller globalt for alle applikasjoner som deployes av helm-chartet. Alle environment-variabler vil overstyre verdier satt i config-filer.

Les mer detaljert rundt bruk av environment-variabler i kubernetes [her](https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/) og .Net [her](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/configuration/?view=aspnetcore-6.0#non-prefixed-environment-variables). Legg spesielt merke til seksjonen rundt [navngivning](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/configuration/?view=aspnetcore-6.0#naming-of-environment-variables) av variabler i .Net:
```
Environment variable names reflect the structure of an appsettings.json file. Each element in the hierarchy is separated by a double underscore (preferable) or a colon. When the element structure includes an array, the array index should be treated as an additional element name in this path. Consider the following appsettings.json file and its equivalent values represented as environment variables.
```
Hvis det er settings i helsenorge-config som skal overstyres så må variabel prefixes med ```HN_```, da det er slik helsenorge-koden plukker opp hvilke variabler som leses inn.

```yaml
extraEnvVars:
    ASPNETCORE_ENVIRONMENT: Dev
    # Overskriver aspnet-core loglevel
    Logging__LogLevel__Default: Info
    # overstyrer settingen ConfigurationSettings:Connectionstring
    HN_ConfigurationSettings_Connectionstring: "Server=sql;Database=databasename;User Id=user;Password=password;"
    # overstyrer rabbit-mq host
    HN_InternalMessagingSettings_RootAddress: "rabbitmq://localhost:5671"
```

Globalt:
```yaml
global:
  extraEnvVars:
    HN_ConfigurationSettings_Connectionstring: "Server=sql;Database=databasename;User Id=user;Password=password;"
```

### EnvFrom configMap eksempler
Som et altnerativ til å definere alle environment-variabler direkte, så kan du opprette ett eller flere config-maps som inneholder de environment-variablene du trenger. 
```yaml
extraEnvVarsCM:
  - configMapRef:
    name: myconfigmap1
  - configMapRef:
    name: myconfigmap2
```
### EnvFrom secret eksempler
Har du en eller flere environment-variabler som skal være hemmelige så kan disse opprettes i en secret og brukes av pod'en som environment-variabler.
```yaml
extraEnvVarsSecret:
  - secretRef:
    name: mysecret1
  - secretRef:
    name: mysecret2
```
### Volume og volumeMount eksempler
Et Volume i kubernetes representerer en filkatalog som er tilgjengelig for alle containere i pod'en. Et volumeMount er mountingen av dette volumet inn i en spesifikk container i pod'en. Det er støtte for en stor mengde forskjellige volumes i kubernetes. Les mer om konseptet [her](https://kubernetes.io/docs/concepts/storage/volumes/).

Eksemplet under vi tilgengeliggjøre 3 volumes av ulik type for podden, og disse vil deretter mountes inn containeren som kjøres i pod'en som filkatalog som igjen kan benyttes applikasjonen i containeren.

```yaml
extraVolumes:
    # tilgjengeliggjøre et tomt volume
  - name: tomt-volume
    emptyDir: {}
    # tilgjengeliggjøre en secret som et volume
  - name: hemmelig-volum1
    secret:
      secretName: navn-paa-secret
    # tilgjengeliggjøre et config-map som et volume
  - name: volume-med-config-fil
    configMap:
      name: navn-paa-config-map
extraVolumeMounts:
    - name: tom-katalog
    mountPath: /tomkatalog
    - name: hemmelig-katalog
    mountPath: /hemmelig
    - name: config-katalog
    mountPath: /config
```
### HostAlias eksempler
Et hostalias overrider resolving av hostname internt i pod'en. Dette fungerer på samme måte som i en hostfil på windows. Kan være nyttig å bruke i utvikling for å peke mot riktig sql-server. Les mer om hostalias i kubernetes [her](https://kubernetes.io/docs/tasks/network/customize-hosts-file-for-pods/)

Eksempelet under peker hostnavnene"sql-mh" og "sql-sec" til ip: "1.2.3.4".
```yaml
hostAliases:
  - ip: 1.2.3.4
  hostnames:
  - sql-mh
  - sql-sec
```

Kan også defineres globalt så det gjelder for alle charts i umbrella chartet:
```yaml
global:
  hostAliases:
  - ip: 1.2.3.4
    hostnames:
    - "sql-mh"
```

Den globale verdien kan igjen overstyres per chart.

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Plattform |  |  |



## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://helsenorge.github.io/helm-charts/ | helsenorge-common | ~0.0.1 |
