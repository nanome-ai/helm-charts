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
        - name: PLUGIN_DESCRIPTION
          value: "{{ .values.global.PLUGIN_DESCRIPTION | default "" }}"
        {{- range $k, $v := .values.ENV }}
        - name: {{ $k }}
          value: "{{ $v }}"
        {{- end }}
        command: ["python", "run.py", "--api-key", "{{ .values.API_KEY }}", "--url", "{{ .values.SERVER_URL }}", "--internal-url", "http://127.0.0.1"]
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
        volumeMounts:
        - name: vol
          mountPath: /root
      volumes:
      - name: vol
        persistentVolumeClaim:
          claimName: {{ $chart_name }}-{{ .release.Name }}-pvc

---

{{- end -}}
