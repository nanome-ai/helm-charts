{{- define "quickdrop.service.tpl" }}
{{- $deployment_name := printf "%s-%s" .chart.Name .release.Name -}}
{{- $chart_name := $.chart.Name -}}

kind: Service
apiVersion: v1

metadata:
  name: {{ $deployment_name }}
  labels:
    app: {{ $chart_name }}
    release: {{ .release.Name }}
spec:
  ports:
    - protocol: TCP
      port: 80
      targetPort: {{ .values.PORT }}
      name: http
  selector:
    app: {{ .chart.Name}}
    release: {{ .release.Name }}
  type: NodePort
{{- end }}
