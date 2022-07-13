{{- define "data-table.service.tpl" }}
{{- $deployment_name := printf "data-table-%s" .release.Name -}}

kind: Service
apiVersion: v1

metadata:
  name: {{ $deployment_name }}
  labels:
    app: {{ $deployment_name }}
    release: {{ .release.Name }}
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
    app: data-table
    release: {{ .release.Name }}
  type: LoadBalancer
{{- end }}
