{{/*
Expand the name of the chart.
*/}}
{{- define "nodejs-express.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "nodejs-express.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else }}
{{- printf "%s-%s" .Release.Name "nodejs-express" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
