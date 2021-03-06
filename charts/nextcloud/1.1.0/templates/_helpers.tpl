{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "nextcloud.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "nextcloud.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "nextcloud.mariadb.fullname" -}}
{{- printf "%s-%s" .Release.Name "mariadb" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Create a default fully qualified redis app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "nextcloud.redis.fullname" -}}
{{- printf "%s-%s" .Release.Name "redis" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "nextcloud.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Retrieve host path from ix volumes based on dataset name
*/}}
{{- define "retrieveHostPathFromiXVolume" -}}
{{- range $index, $hostPathConfiguration := $.ixVolumes }}
{{- $dsName := base $hostPathConfiguration.hostPath -}}
{{- if eq $.datasetName $dsName -}}
{{- $hostPathConfiguration.hostPath -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Retrieve host path defined in volume
*/}}
{{- define "configuredHostPath" -}}
{{- if .Values.emptyDirVolumes -}}
{{- printf "" -}}
{{- else if .Values.nextcloudDataHostPathEnabled -}}
{{- required "Please specify a host path for nextcloud" .Values.nextcloudHostPath -}}
{{- else -}}
{{- $volDict := dict "datasetName" $.Values.nextcloudDataVolume.datasetName "ixVolumes" $.Values.ixVolumes -}}
{{- include "retrieveHostPathFromiXVolume" $volDict -}}
{{- end -}}
{{- end -}}

{{/*
Retrieve backup postgresql host path defined in volume
*/}}
{{- define "configuredBackupPostgresHostPath" -}}
{{- if .Values.emptyDirVolumes -}}
{{- printf "" -}}
{{- else -}}
{{- $volDict := dict "datasetName" $.Values.postgresBackupVolume.datasetName "ixVolumes" $.Values.ixVolumes -}}
{{- include "retrieveHostPathFromiXVolume" $volDict -}}
{{- end -}}
{{- end -}}

{{/*
Retrieve postgresql data host path defined in volume
*/}}
{{- define "configuredPostgresHostPath" -}}
{{- if .Values.emptyDirVolumes -}}
{{- printf "" -}}
{{- else -}}
{{- $volDict := dict "datasetName" $.Values.postgresDataVolume.datasetName "ixVolumes" $.Values.ixVolumes -}}
{{- include "retrieveHostPathFromiXVolume" $volDict -}}
{{- end -}}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "nextcloud.selectorLabels" -}}
app.kubernetes.io/name: {{ include "nextcloud.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Nextcloud service account
*/}}
{{- define "nextcloud.serviceAccountName" -}}
{{- printf "%s-service-account" .Release.Name -}}
{{- end -}}
