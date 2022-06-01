{{ $data := dict "values" $.Values.jupyter_notebook "release" $.Release "global" $.Values.global }}
{{- include "cookbook.jupyter_deployment.tpl" $data }}
