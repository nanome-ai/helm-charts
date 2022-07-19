{{- define "vault.pvc.tpl" -}}
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {{ .chart.Name }}-{{ .release.Name }}-pvc
spec:
  accessModes:
    - ReadWriteOnce
  volumeName: {{.values.VOLUME_NAME}}
  resources:
    requests:
      storage: 1Gi
{{- end -}}
