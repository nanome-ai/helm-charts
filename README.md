# Nanome Helm Charts
Easily deploy nanome plugins to your Kubernetes cluster!

## Add repo to helm
```sh
helm repo add nanome https://nanome-ai.github.io/helm-charts/
```
## Deploy Starter Stack
```sh
helm install --generate-name nanome/starter-stack
```

## Deploy an individual plugin
```sh
helm install --generate-name nanome/chemical-interactions -v values.yaml
```
