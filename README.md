# helsenorge-helm-charts
Helm-charts skrevet for å deploy Helsenorge til kubernetes.

Inneholder følgende charts
- [helsenorge-application](charts/helsenorge-application/README.md) - chart for å deploye en helsenorge-applikasjon (api, webapp, batchjobb etc).
- [helsenorge-job](charts/helsenorge-job/README.md) - chart for å deploye en helsenorge-engangsjobb (databasemigrering, console-app etc).
- [helsenorge-common](charts/helsenorge-common/READNE.md) - [library-chart](https://helm.sh/docs/topics/library_charts/) de ovenstående chartene har en avhengighet til. Felles templates osv.

## Installasjon av repo
For å få tilgang til repoet lokalt, kjøre følgende kommando: 
```console
$ helm repo add helsenorge http://helsenorge.github.io/helm-charts
```
## Ta i bruk i løsningsområde 
Chartene i dette repoet skal benyttes som endel av et umbrella-chart for å installere et helsenorge-løsningsområde.

### Opprette chart for løsningsområde

Stå i helsenorge-repoet du ønsker å deploye til kubernetes. Hvis losningsområdet ditt heter "okonomi"

Opprett nytt helm-chart under folder ```/charts```
```console 
mkdir charts
helm create okonomi
```
Vi skal bare lage et umbrella chart der vi inkluderer allerede eksisterende helm-charts, så du trenger ikke den templatingen ```helm create``` gir by default.
```console
rm -rf okonomi/templates/*
```
Du sitter nå igjen med en ```Chart.yml```, en ```.helmignore``` og en ```values.yaml``` under /charts i ditt repo.

### Konfigurere chart
```chart.yaml``` beskriver metadata om chartet vi akkurat har laget. Les mer om ```chart.yaml``` og hva den bør inneholde [her](https://helm.sh/docs/topics/charts/#the-chartyaml-file). Minimum så bør den ha en kort beskrivelse, en versjon og en peker til hvem som er ansvarlige. ```Values.yaml``` inneholder konfigurasjonen som benyttes når chartet deployes til kubernetes. Her overkriver vi alle default-verdiene som gjør vår deployment unik for løsningsområdet. ```.helmignore``` brukes for å ignorere filer når vi senere skal kjøre bygging av helm-chart til en pakke. 

#### chart.yaml

```yaml
apiVersion: v2
name: okonomi
description: Et umbrella chart som beskriver deployment av løsningsområde 'okonomi' til et helsenorge kubernetes miljø
type: application
version: 0.1.0

maintainers:
  - name: Plattform
```
I tillegg så må chart ```chart.yaml``` inneholde èn dependency per applikasjon, migrering eller console som løsningsområde inneholder. Les mer om helm-dependencies [her](https://helm.sh/docs/helm/helm_dependency/)

Hvis løsningsområdet inneholder 2 apier og 1 migrering så kunne det sett ut som under. Legg merke til bruken av alias. Dette gir oss mulighetene til å gjenbruke samme chart mange ganger, og samtidig konfigurere de ulikt.

```yaml
dependencies:
- name: helsenorge-applikasjon
  version: "~0.0.1"
  repository: "https://helsenorge.github.io/helm-charts/"
  alias: externalapi
- name: helsenorge-applikasjon
  version: "~0.0.1"
  repository: "https://helsenorge.github.io/helm-charts/"
  alias: internalapi
- name: helsenorge-job
  version: "~0.0.1"
  repository: "https://helsenorge.github.io/helm-charts/"
  alias: database
```

#### Values.yaml
```values.yaml``` brukes for å konfigurere et helm-chart. ```values.yaml``` filen er en av flere måter å gjøre dette på, men den mest vanlige. Les mer om dette [her](https://helm.sh/docs/chart_template_guide/values_files/) 

Todo...


#### Extensions
Hvis felles-chartene ikke dekker dine behov, kan du extende dette...

Todo...

## Generer dokumentasjon 
Benytter oss av [helm-docs](https://github.com/norwoodj/helm-docs) for å auto-generere helm-chart dokumentasjon.

1. Ha docker kjørende
2. Stå på rot i repoet
3. Kjør i terminal:

```console
docker run --rm --volume "$(pwd):/src"  jnorwood/helm-docs:latest --chart-search-root=/src/. --template-files=/src/charts/_templates.gotmpl --template-files=README.md.gotmpl --sort-values-order file
``` 