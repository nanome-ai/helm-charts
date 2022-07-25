{{- define "vault.deployment.tpl" }}

{{- $plugin_image := .values.plugin_image -}}
{{- $plugin_tag :=  .values.plugin_tag | default $.chart.AppVersion -}}

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
          value: "{{ .values.global.PLUGIN_VERBOSE }}"
        - name: PLUGIN_WRITE_LOG_FILE
          value: "{{ .values.global.PLUGIN_WRITE_LOG_FILE }}"
        - name: PLUGIN_REMOTE_LOGGING
          value: "{{ .values.global.PLUGIN_REMOTE_LOGGING | default "false" }}"
        - name: PLUGIN_NAME
          value: "{{ $plugin_name }}"
        - name: SERVER_URL
          value: "{{ .values.SERVER_URL }}"
        - name: API_KEY
          value: "{{ .values.API_KEY }}"
        - name: CONVERTER_URL
          value: "{{ .values.CONVERTER_URL }}"
        resources:
          requests:
            memory: "80Mi"
            cpu: "100m"
          limits:
            memory: "512Mi"
            cpu: "1000m"
      - name: vault-server
        image: {{ .values.server_image }}:{{ .values.server_tag }}
        ports:
        - containerPort: 80
        - containerPort: 443
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
