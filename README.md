# helsenorge-helm-charts

### Generer dokumentasjon ###
Benytter oss av [helm-docs](https://github.com/norwoodj/helm-docs) for å auto-generere helm-chart dokumentasjon.

1. Ha docker-desktop kjørende
2. Stå på rot i repoet
3. Kjør i powershell terminal:

```powershell
docker run --rm --volume "$(pwd):/helm-docs"  jnorwood/helm-docs:latest
```