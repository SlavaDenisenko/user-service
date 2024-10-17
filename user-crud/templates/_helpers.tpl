{{/*
Expand the name of the chart.
*/}}
{{- define "user-crud.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "user-crud.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create a complete URL to connect to the database
*/}}
{{- define "user-crud.fullUrl" -}}
{{- printf "jdbc:postgresql://%s:%d/%s" .Values.db.service.name (int .Values.db.service.port) .Values.db.connection.name -}}
{{- end }}

{{/*
Create a complete image name for the database migration tool
*/}}
{{- define "user-crud.migration.image" -}}
{{- printf "%s:%s" .Values.migration.image.repository .Values.migration.image.tag -}}
{{- end }}

{{/*
Create a complete image name for the application
*/}}
{{- define "user-crud.application.image" -}}
{{- $tag := default .Chart.AppVersion .Values.application.image.tag }}
{{- printf "%s:%s" .Values.application.image.repository $tag -}}
{{- end }}

{{/*
Create a complete image name for the database
*/}}
{{- define "user-crud.db.image" -}}
{{- printf "%s:%s" .Values.db.container.image.repository .Values.db.container.image.tag -}}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "user-crud.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "user-crud.labels" -}}
helm.sh/chart: {{ include "user-crud.chart" . }}
{{ include "user-crud.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "user-crud.selectorLabels" -}}
app.kubernetes.io/name: {{ include "user-crud.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "user-crud.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "user-crud.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
