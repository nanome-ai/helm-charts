{{- define "data-table-server.tpl" }}
{{-  $deployment_name := printf "data-table-server-%s" .release.Name -}}

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
      - name: data-table-server
        image: {{ .values.image }}{{ .chart.AppVersion }}
        ports:
        - containerPort: 80
        - containerPort: 443
        resources:
            requests:
              memory: "32Mi"
              cpu: "128m"
            limits:
              memory: "128Mi"
              cpu: "500m"

---

kind: Service
apiVersion: v1

metadata:
  name: {{ $deployment_name }}
  labels:
    app: {{ $deployment_name }}
  annotations:
    "helm.sh/resource-policy": keep
spec:
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      name: http
    - protocol: TCP
      port: 443
      targetPort: 443
      name: https
  selector:
    app: {{ $deployment_name }}
    release: {{ .release.Name }}
  type: LoadBalancer


{{- end }}
