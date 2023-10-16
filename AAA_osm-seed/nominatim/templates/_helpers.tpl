{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}

{{- define "name" -}}
{{- default "nominatim" .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "fullname" -}}
{{- $name := default "nominatim" .Values.nameOverride -}}
{{- $deploymentName:= default "dev" .Values.deploymentName -}}
{{- printf "%s-%s" $name $deploymentName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "nominatimService" -}}
{{- $name := default "nominatim" .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- $deploymentName:= default "dev" .Values.deploymentName -}}
{{- printf "%s-%s" $name $deploymentName | trunc 63 | trimSuffix "-" -}}
{{- end -}}
