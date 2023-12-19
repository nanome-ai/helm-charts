{{- define "data-table.service.tpl" }}
{{- $deployment_name := printf "%s-%s" .chart.Name .release.Name -}}

kind: Service
apiVersion: v1

metadata:
  name: {{ $deployment_name }}
  labels:
    app: {{ $deployment_name }}
    release: {{ .release.Name }}
spec:
  ports:
    - protocol: TCP
      port: {{ .values.server.HTTP_PORT }}
      targetPort: {{ .values.server.HTTP_PORT }}
      name: http
    - protocol: TCP
      port: {{ .values.server.HTTPS_PORT }}
      targetPort: {{ .values.server.HTTPS_PORT }}
      name: https
  selector:
    app: {{ .chart.Name}}
    release: {{ .release.Name }}
  type: NodePort
{{- end }}
