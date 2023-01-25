{{- define "vault.deployment.tpl" }}

{{- $plugin_image := .values.plugin.image.name -}}
{{- $plugin_tag :=  .values.plugin.image.tag | default $.chart.AppVersion -}}

{{- $server_image := .values.server.image.name -}}
{{- $server_tag :=  .values.server.image.tag | default $.chart.AppVersion -}}

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
        image: {{ $plugin_image }}:{{ $plugin_tag }}
        env:
        - name: NTS_HOST
          value: "{{ .values.global.NTS_HOST }}"
        - name: NTS_PORT
          value: "{{ .values.global.NTS_PORT }}"
        - name: NTS_KEY
          value: "{{ .values.global.NTS_KEY }}"
        - name: PLUGIN_VERBOSE
          value: "{{ .values.global.PLUGIN_VERBOSE | default "false"}}"
        - name: PLUGIN_WRITE_LOG_FILE
          value: "{{ .values.global.PLUGIN_WRITE_LOG_FILE | default "true" }}"
        - name: PLUGIN_REMOTE_LOGGING
          value: "{{ .values.global.PLUGIN_REMOTE_LOGGING | default "false" }}"
        - name: PLUGIN_NAME
          value: "{{ $plugin_name }}"
        - name: VAULT_URL
          value: "{{ .values.VAULT_URL }}"
        - name: API_KEY
          value: "{{ .values.API_KEY }}"
        - name: CONVERTER_URL
          value: "{{ .values.CONVERTER_URL }}"
        - name: HTTPS
          value: "{{ .values.HTTPS | default "true" }}"
        - name: INTERNAL_URL
          value: "{{ .values.plugin.INTERNAL_URL }}"
        resources:
          requests:
            memory: "80Mi"
            cpu: "100m"
          limits:
            memory: "512Mi"
            cpu: "1000m"
      - name: vault-server
        image: {{ $server_image }}:{{ $server_tag }}
        ports:
        - containerPort: {{ .values.server.HTTPS_PORT }}
        - containerPort: {{ .values.server.HTTPS_PORT }}
        resources:
          requests:
            memory: "32Mi"
            cpu: "128m"
          limits:
            memory: "64Mi"
            cpu: "256m"
        env:
        - name: SERVER_URL
          value: "{{ .values.SERVER_URL }}"
        - name: API_KEY
          value: "{{ .values.API_KEY }}"
        - name: HTTPS_PORT
          value: "{{ .values.server.HTTPS_PORT }}"
        - name: HTTP_PORT
          value: "{{ .values.server.HTTP_PORT }}"
        volumeMounts:
        - name: vol
          mountPath: /root
      - name: vault-converter
        image: thecodingmachine/gotenberg:6
        ports:
        - containerPort: 3000
        env:
        - name: DISABLE_GOOGLE_CHROME
          value: "1"
        - name: MAXIMUM_WAIT_TIMEOUT
          value: "0"
        - name: DEFAULT_WAIT_TIMEOUT
          value: "0"
      volumes:
      - name: vol
        persistentVolumeClaim:
          claimName: {{ $chart_name }}-{{ .release.Name }}-pvc

---

{{- end -}}
