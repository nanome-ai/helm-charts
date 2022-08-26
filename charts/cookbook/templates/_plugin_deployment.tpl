{{- define "cookbook.plugin_deployment.tpl" }}
{{- $plugin_image := .values.image -}}
{{- $plugin_tag := .chart.AppVersion -}}

{{- $chart_name := .chart.Name -}}
{{- $plugin_name := .values.PLUGIN_NAME -}}

apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ $chart_name }}-{{ .release.Name }}
  labels:
    app: {{ $chart_name }}
    release: {{ .release.Name }}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: {{ $chart_name }}-{{ .release.Name }}
      release: {{ .release.Name }}
  template:
    metadata:
      labels:
        app: {{ $chart_name }}-{{ .release.Name }}
        release: {{ .release.Name }}
    spec:
      containers:
      - name: {{ $chart_name }}
        image: {{ $plugin_image }}:{{ $plugin_tag }}
        ports:
        - containerPort: {{ .values.NTS_PORT}}
        env:
        - name: NTS_HOST
          value: "{{ .values.NTS_HOST }}"
        - name: NTS_PORT
          value: "{{ .values.NTS_PORT }}"
        - name: NTS_KEY
          value: "{{ .values.NTS_KEY }}"
        resources:
          requests:
            memory: "80Mi"
            cpu: "100m"
          limits:
            memory: "512Mi"
            cpu: "1000m"
---
{{- end -}}