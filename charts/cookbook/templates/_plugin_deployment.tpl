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
        - name: PLUGIN_VERBOSE
          value: "{{ .values.PLUGIN_VERBOSE }}"
        - name: PLUGIN_WRITE_LOG_FILE
          value: "{{ .values.PLUGIN_WRITE_LOG_FILE }}"
        - name: PLUGIN_REMOTE_LOGGING
          value: "{{ .values.PLUGIN_REMOTE_LOGGING | default "false" }}"
        - name: PLUGIN_NAME
          value: "{{ $plugin_name }}"
        - name: PLUGIN_DESCRIPTION
          value: "{{ .values.PLUGIN_DESCRIPTION | default "" }}"
        - name: DEFAULT_URL
          value: "{{ .values.DEFAULT_URL | default "" }}"
        - name: REDIS_HOST
          value: "{{ .global.REDIS_HOST | default "" }}"
        - name: REDIS_PORT
          value: "{{ .global.REDIS_PORT | default "" }}"
        - name: REDIS_PASSWORD
          value: "{{ .global.REDIS_PASSWORD | default "" }}"
        - name: REDIS_CHANNEL
          value: "{{ .global.REDIS_CHANNEL | default "" }}"
        - name: JUPYTER_TOKEN
          value: "{{ .global.JUPYTER_TOKEN | default "" }}"
        
          
        resources:
          requests:
            memory: "80Mi"
            cpu: "100m"
          limits:
            memory: "512Mi"
            cpu: "1000m"
      imagePullSecrets:
      - name: regcred
---

{{- end -}}
       