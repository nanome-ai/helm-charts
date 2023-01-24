{{- define "vault.pvc.tpl" -}}
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {{ .chart.Name }}-{{ .release.Name }}-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: "{{ .values.server.PVC_STORAGE | default "1Gi" }}"
{{- end -}}
