{{- define "cookbook.jupyter_deployment.tpl" }}
{{- $image := .values.image -}}
{{- $tag := .values.tag -}}

apiVersion: apps/v1
kind: Deployment
metadata:
  name: jupyter-{{ .release.Name }}
  labels:
    app: jupyter
    release: {{ .release.Name }}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: jupyter-{{ .release.Name }}
      release: {{ .release.Name }}
  template:
    metadata:
      labels:
        app: jupyter-{{ .release.Name }}
        release: {{ .release.Name }}
    spec:
      containers:
      - name: jupyter
        image: {{ $image }}:{{ $tag }}
        imagePullPolicy: Always
        ports:
        - containerPort: 8888
        env:
        - name: REDIS_HOST
          value: "{{ .global.REDIS_HOST }}"
        - name: REDIS_PORT
          value: "{{ .global.REDIS_PORT }}"
        - name: REDIS_PASSWORD
          value: "{{ .global.REDIS_PASSWORD }}"
        - name: REDIS_CHANNEL
          value: "{{ .global.REDIS_CHANNEL }}"
        - name: JUPYTER_ENABLE_LAB
          value: "yes"
        - name: JUPYTER_TOKEN
          value: "{{ .values.JUPYTER_TOKEN | default "change_me" }}"
        resources:
          requests:
            memory: "80Mi"
            cpu: "100m"
          limits:
            memory: "512Mi"
            cpu: "1000m"
---
{{- end -}}
