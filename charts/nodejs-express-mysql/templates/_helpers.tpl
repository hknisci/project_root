{{/*
Expand the name of the chart.
*/}}
{{- define "nodejs-express-mysql.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "nodejs-express-mysql.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else }}
{{- printf "%s-%s" .Release.Name "nodejs-express-mysql" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
