# Nanome Helm Charts
Easily deploy nanome plugins to your Kubernetes cluster!

https://nanome-ai.github.io/helm-charts/

## Deploy Starter Stack
```sh
helm dependencies update nanome/starter-stack
helm install --generate-name nanome/starter-stack
```

## Deploy an individual plugin
```sh
helm dependencies update nanome/plugins/chemical-interactions
helm install --generate-name nanome/plugins/chemical-interactions
```
