{{- define "cookbook.jupyter_service.tpl" }}
{{-  $deployment_name := printf "jupyter-%s" .release.Name -}}

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
      port: 8888
      targetPort: 8888
      name: http
    - protocol: TCP
      port: 443
      targetPort: 443
      name: https
  selector:
    app: {{ $deployment_name }}
    release: {{ .release.Name }}
  type: LoadBalancer
---
{{- end }}