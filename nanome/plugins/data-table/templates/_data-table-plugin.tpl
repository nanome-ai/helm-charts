{{- define "data-table-plugin.deployment.tpl" }}
{{- $plugin_name := .values.PLUGIN_NAME | default "" -}}
{{- $plugin_image := .values.image -}}
{{- $plugin_tag := .values.tag -}}
{{- $chart_name := .chart.Name -}}
{{- $global := .global -}}

{{-  $deployment_name := printf "data-table-plugin-%s" .release.Name -}}

apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ $deployment_name }}
  labels:
    app: {{ $deployment_name }}
    release: {{ .release.Name }}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: {{ $deployment_name }}
      release: {{ .release.Name }}
  template:
    metadata:
      labels:
        app: {{ $deployment_name }}
        release: {{ .release.Name }}
      annotations:
        rollme: {{ randAlphaNum 5 | quote }}
    spec:
      containers:
      - name: {{ $chart_name | lower }}
        image: {{ $plugin_image }}
        ports:
        - containerPort: {{ $global.NTS_PORT }}
        env:
        - name: ARGS
          value: "-u {{ .values.server_url }}"
        - name: NTS_HOST
          value: "{{ $global.NTS_HOST }}"
        - name: NTS_PORT
          value: "{{ $global.NTS_PORT }}"
        - name: NTS_KEY
          value: "{{ $global.NTS_KEY }}"
        - name: PLUGIN_VERBOSE
          value: "{{ $global.PLUGIN_VERBOSE }}"
        - name: PLUGIN_WRITE_LOG_FILE
          value: "{{ $global.PLUGIN_WRITE_LOG_FILE }}"
        - name: PLUGIN_REMOTE_LOGGING
          value: "{{ $global.PLUGIN_REMOTE_LOGGING | default "false" }}"
        - name: PLUGIN_NAME
          value: "{{ $plugin_name }}"

{{- end -}}
---