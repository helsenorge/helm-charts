



# helsenorge-job


Helm chart for installere en helsenorge-job på kuberntes. En job beskriver en engangskjøring av en eller flere pod'er ved deploy. Passer for kjøring databasemigreringer eller console applikasjoner.

## Installasjon

Dette chartet er ment for å inkluderes i et [umbrella chart](https://helm.sh/docs/howto/charts_tips_and_tricks/#complex-charts-with-many-dependencies) for å deploye et helsenorge-løsningsområde, men kan også installeres enkeltvis. Les mer om dette her.

For å installere chartet med navnet "my-release"
```console
$ helm repo add helsenorge http://helsenorge.github.io/helm-charts
$ helm install my-release helsenorge/helsenorge-job
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nameOverride | string | `""` | Overrider navn på chart. Beholder release-navnet |
| fullnameOverride | string | `""` | Overrider navn på chart.  |
| teamOvveride | string | `""` | Hentes fra Chart.Maintainers[0].name (Chart.yaml) - Kan ovverides ved behov, også globalt. |
| image | string | `nil` | Image referanse: registry/repository:tag |
| imagePullPolicy | string | `nil` | Pull-policy satt på imaget |
| command | string | `nil` | Ovveride default container command - defaulter til "dotnet" - Les mer om Command and Arguments for kontainere [her](https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/). |
| args | string | `nil` | Ovveride default container args - Les mer om Command and Arguments for kontainere [her](https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/). |
| commonLabels | string | `nil` | Labels som legges på alle objeckter som deployes |
| commonAnnotations | string | `nil` | Annoteringer som legges på alle objeckter som deployes  |
| restartPolicy | string | `"Never"` | Restart policien til en pod. Defaulter til Never for en engangsjobb. Mulige verdier er Always, OnFailure, and Never. Les mer [her](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#restart-policy). |
| backoffLimit | int | `1` | Antall forsøk jobben får før den markeres som feilet |
| extraEnvVars | object | `{}` | Map av environment variabler som tilgjengeliggjøres for podden. Se [her](env-eksempler) for eksempler. |
| extraEnvVarsCM | list | `[]` | Liste over eksisterende config-maps der innholdet lastes inn i podden som envVars. Se [her](#envfrom-configmap-eksempler) for eksempler.  |
| extraEnvVarsSecret | list | `[]` | Liste over eksisterende secrets der innholdet lastes inn i podden som envVars. Se [her](#envfrom-secret-eksempler) for eksempler. |
| extraVolumes | list | `[]` | Liste over extra volumes som skal tilgjengeliggjøres til deploymenten. Se [her](#volume-og-volumemount-eksempler) for eksempler. |
| extraVolumeMounts | list | `[]` | Liste over extra volume mounts som skal mountes til podden. Se [her](#volume-og-volumemount-eksempler) for eksempler. |
| serviceAccount | object | `{"create":true,"imagePullSecrets":["helsenorge-pull-secret"]}` | Kubernetes service-konto. Les mer [her](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/). Navn settes til det samme som applikasjon. |
| serviceAccount.create | bool | `true` | Spesifiserer om en service-konto skal opprettes. |
| serviceAccount.imagePullSecrets | list | `["helsenorge-pull-secret"]` | Legger på egne image pull secrets på service accounten. Gjør det mulig for pods som kjører under denne service-accounten å få tilgang til private registry |
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