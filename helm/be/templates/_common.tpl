{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "app-demo.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create Argo CD app version
*/}}
{{- define "app-demo.defaultTag" -}}
{{- default .Chart.AppVersion .Values.global.image.tag }}
{{- end -}}