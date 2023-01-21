{{- define "structure_prep.plugin_deployment.tpl" }}
{{- $plugin_image := .values.image.name -}}
{{- $plugin_tag :=  .values.image.tag | default $.chart.AppVersion -}}

{{- $chart_name := $.chart.Name -}}
{{- $plugin_name := .values.PLUGIN_NAME | default "" -}}

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
        env:
        - name: NTS_HOST
          value: "{{ .values.global.NTS_HOST }}"
        - name: NTS_PORT
          value: "{{ .values.global.NTS_PORT }}"
        - name: NTS_KEY
          value: "{{ .values.global.NTS_KEY }}"
        - name: PLUGIN_VERBOSE
          value: "{{ .values.global.PLUGIN_VERBOSE }}"
        - name: PLUGIN_WRITE_LOG_FILE
          value: "{{ .values.global.PLUGIN_WRITE_LOG_FILE }}"
        - name: PLUGIN_REMOTE_LOGGING
          value: "{{ .values.global.PLUGIN_REMOTE_LOGGING | default "false" }}"
        - name: PLUGIN_NAME
          value: "{{ $plugin_name }}"
        {{- range $k, $v := .values.ENV }}
        - name: {{ $k }}
          value: "{{ $v }}"
        {{- end }}
        resources:
          requests:
            memory: "80Mi"
            cpu: "10m"
          limits:
            memory: "512Mi"
            cpu: 1
---

{{- end -}}
       