{{- define "deployment.fullname" }}
{{- printf "%s-deploy" .Values.namespace.name }}
{{- end }}

{{- define "pod.fullname" }}
{{- printf "%s-pod" .Values.namespace.name }}
{{- end }}

{{- define "container.fullname" }}
{{- printf "%s-server" .Values.namespace.name }}
{{- end }}

{{- define "container.image" }}
{{- printf "%s:%s" .Values.deployment.image.name .Values.deployment.image.version -}}
{{- end }}

{{- define "service.fullname" }}
{{- printf "%s-svc" .Values.namespace.name }}
{{- end }}

{{- define "port.container.range" }}
{{- $initiPort := .Values.service.imposters.portRange.initPort -}}
{{- $endPort := .Values.service.imposters.portRange.endPort -}}
{{- $loop := sub $endPort $initiPort -}}
{{- if ge $loop 1 }}
ports:
- containerPort: {{ .Values.service.port }}
  name: {{ printf "svc-%d" (int .Values.service.port) }}
  protocol: TCP
{{- range untilStep (int $initiPort) (int (add $endPort 1)) 1 }}
- containerPort: {{ . }}
  name: {{ printf "imps-%d" . }}
  protocol: TCP
{{- end }}
{{- end }}
{{- end }}

{{- define "port.service.range" }}
{{- $initiPort := .Values.service.imposters.portRange.initPort -}}
{{- $endPort := .Values.service.imposters.portRange.endPort -}}
{{- $loop := sub $endPort $initiPort -}}
{{- if ge $loop 1 }}
ports:
- port: {{ .Values.service.port }}
  targetPort: {{ .Values.service.port }}
  name: {{ printf "svc-%d" (int .Values.service.port) }}
  protocol: TCP
{{- range untilStep (int $initiPort) (int (add $endPort 1)) 1 }}
- port: {{ . }}
  targetPort: {{ . }}
  name: {{ printf "imps-%d" . }}
  protocol: TCP
{{- end }}
{{- end }}
{{- end }}

{{- define "pod.security.context" }}
securityContext:
  runAsUser: {{ .Values.security.context.userId }}
  {{- if .Values.security.context.isRoot -}}
  runAsNonRoot: false
  {{- else }}
  runAsNonRoot: true
  {{- end }}
  privileged: {{ .Values.security.context.isPrivileged }}
{{- end }}

{{/*{{- define "pod.extra.arguments" }}*/}}
{{/*{{- if and (ne .Values.deployment.extraArgs nil) (gt (len .Values.deployment.extraArgs) 0) }}*/}}
{{/*args:*/}}
{{/*  {{- range .Values.deployment.extraArgs }}*/}}
{{/*  - {{ . }}*/}}
{{/*  {{- end -}}*/}}
{{/*{{- end -}}*/}}
{{/*{{- end -}}*/}}

{{- define "pod.extra.arguments" }}
{{- if (gt (len .Values.deployment.extraArgs) 0) }}
args:
  {{- range .Values.deployment.extraArgs }}
  - {{ . }}
  {{- end -}}
{{- end -}}
{{- end -}}
