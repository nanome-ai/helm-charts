{{- define "quickdrop.deployment.tpl" }}

{{- $app_image := .values.image.name -}}
{{- $app_tag :=  .values.image.tag | default $.chart.AppVersion -}}

{{- $chart_name := $.chart.Name -}}

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
      app: {{ $chart_name }}
      release: {{ .release.Name }}
  template:
    metadata:
      labels:
        app: {{ $chart_name }}
        release: {{ .release.Name }}
    spec:
      containers:
      - name: {{ $chart_name }}
        image: {{ $app_image }}:{{ $app_tag }}
        imagePullPolicy: Always
        resources:
          requests:
            memory: "80Mi"
            cpu: "100m"
          limits:
            memory: "512Mi"
            cpu: "1000m"
      env:
        - PORT: "{{ .values.PORT }}"
        - FILES_DIR: "{{ .values.FILES_DIR }}"
        - HTTPS: "{{ .values.HTTPS }}"
        - BASE_URL: "{{ .values.BASE_URL }}"
---

{{- end -}}
