{{- define "quickdrop.pvc.tpl" -}}
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {{ .chart.Name }}-{{ .release.Name }}-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: "{{ .values.PVC_STORAGE | default "1Gi" }}"
{{- end -}}
