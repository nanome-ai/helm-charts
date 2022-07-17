{{- define "vault.pvc.tpl" }}
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {{ .chart.Name }}-{{ .release.Name }}-pvc
spec:
  storageClassName: local-storage
  accessModes:
    - ReadWriteMany
  volumeName: {{ .chart.Name }}-{{ .release.Name }}-pv
  resources:
    requests:
      storage: 1Gi
{{- end -}}
