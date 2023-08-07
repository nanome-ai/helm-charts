{{- define "getDir" -}}
{{- $pathList := splitList "/" . -}}
{{- $result := list -}}
{{- $lastIndex := sub (len $pathList) 1 -}}
{{- range $index, $element := $pathList -}}
{{- if ne $index $lastIndex -}}
{{- $result = append $result $element -}}
{{- end -}}
{{- end -}}
{{- join "/" $result -}}
{{- end -}}