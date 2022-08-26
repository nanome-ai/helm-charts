# Nanome Helm Charts
Easily deploy nanome plugins to your Kubernetes cluster!

## Add repo to helm
```sh
helm repo add nanome https://nanome-ai.github.io/helm-charts/
```

## View available charts
```sh
helm search repo nanome
```

## Deploy Starter Stack (Includes charts for all standard plugins)
```sh
helm install --generate-name nanome/starter-stack -f values.yaml
```

## Deploy an individual plugin
```sh
helm install --generate-name nanome/chemical-interactions -f values.yaml
```

## values.yaml
This values.yaml should work for most plugins, although some plugins have additional requirements. See `values.yaml` in each chart for specific requirements.
```yaml
global:
  NTS_HOST:
  NTS_PORT:
  NTS_KEY:
  PLUGIN_VERBOSE:
  PLUGIN_WRITE_LOG_FILE: true
  PLUGIN_REMOTE_LOGGING: false
```
