{{- define "vault.pvc.tpl" -}}
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {{ .chart.Name }}-{{ .release.Name }}-pvc
spec:
  accessModes:
    - ReadWriteOnce
  volumeName: {{ .values.PV_NAME }}
  resources:
    requests:
      storage: "{{ .values.PVC_STORAGE | default "1Gi" }}"
{{- end -}}
