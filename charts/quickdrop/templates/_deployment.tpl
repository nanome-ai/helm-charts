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
          - name: PORT
            value: "{{ .values.PORT }}"
          - name: FILES_DIR
            value: "{{ .values.FILES_DIR }}"
          - name: HTTPS
            value: "{{ .values.HTTPS }}"
          - name: BASE_URL
            value: "{{ .values.BASE_URL }}"
          - name: DATABASE_PATH
            value: "{{ .values.DATABASE_PATH }}"
        volumeMounts:
        - name: vol
          mountPath: {{ .values.VOLUME_MOUNT_PATH }}
      volumes:
      - name: vol
        persistentVolumeClaim:
          claimName: {{ $chart_name }}-{{ .release.Name }}-pvc
---

{{- end -}}
