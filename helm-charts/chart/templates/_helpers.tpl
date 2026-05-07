{{- define "chartname.podTemplate" -}}
{{- if hasKey .Values "securityContext" }}
securityContext:
runAsUser: {{ .Values.securityContext.runAsUser }}
runAsGroup: {{ .Values.securityContext.runAsGroup }}
{{- end }}
{{- if hasKey .Values "tolerations"}}
tolerations:
{{- with .Values.tolerations -}}
{{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}
{{- if hasKey .Values "nodeSelector" }}
nodeSelector:
{{- range $key, $value := .Values.nodeSelector }}
  {{ $key }}: '{{ $value }}'
{{- end }}
{{- end }}
{{- if or (hasKey .Values "nodeAffinity") (hasKey .Values "podAntiAffinity") }}
affinity:
  {{- if hasKey .Values "nodeAffinity" }}
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
      - matchExpressions:
        {{- range .Values.nodeAffinity }}
        - key: {{ .key }}
          operator: {{ .operator }}
          values:
          - {{ .value }}
        {{- end }}
  {{- end }}
  {{- if hasKey .Values "podAntiAffinity" }}
  podAntiAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
    - labelSelector:
        matchExpressions:
        {{- range .Values.podAntiAffinity }}
        - key: {{ .key }}
          operator: {{ .operator }}
          values:
          - {{ .value }}
        {{- end }}
      # topologyKey: "kubernetes.io/hostname" ensures pods are spread across different nodes based on their hostname
      topologyKey: "kubernetes.io/hostname" 
  {{- end }}
{{- end }}
containers:
- name: {{ .Values.name }}
  envFrom:
  {{- if hasKey .Values "config" }}
  - configMapRef:
      name: '{{ .Values.name }}-configmap'
  {{- end }}
  {{- if hasKey .Values "secrets" }}
  - secretRef:
      name: '{{ .Values.name }}-secret'
  {{- end }}
  env:
    {{- if hasKey .Values "command" }}
    - name: command
      value: {{ .Values.command }}
    {{- end }}
    {{- if hasKey .Values "additionalEnvsFrom" }}
    {{- range .Values.additionalEnvsFrom }}
    - name: {{ .name }}
      valueFrom:
        {{- toYaml .valueFrom | nindent 8 }}
    {{- end }}
    {{- end }}
    {{- if hasKey .Values "additionalEnvs" }}
    {{- range .Values.additionalEnvs }}
    - name: {{ .name }}
      value: {{ .value }}
    {{- end }}
    {{- end }}
  {{- if hasKey .Values.deployment.image "name" }}
  image: {{ .Values.global.repo }}/{{ .Values.deployment.image.name }}:{{ .Values.deployment.image.tag }}
  {{- else }}
  image: {{ .Values.global.repo }}/{{ .Values.name }}:{{ .Values.deployment.image.tag }}
  {{- end }}
  imagePullPolicy: IfNotPresent
  {{- if hasKey .Values "resources" }}
  resources:
    {{- if .Values.resources.requests }}
    requests:
      {{- if .Values.resources.requests.cpu }}
      cpu: {{ .Values.resources.requests.cpu }}
      {{- end }}
      {{- if .Values.resources.requests.memory }}
      memory: {{ .Values.resources.requests.memory }}
      {{- end }}
    {{- end }}
    {{- if .Values.resources.limits }}
    limits:
      {{- if .Values.resources.limits.cpu }}
      cpu: {{ .Values.resources.limits.cpu }}
      {{- end }}
      {{- if .Values.resources.limits.memory }}
      memory: {{ .Values.resources.limits.memory }}
      {{- end }}
    {{- end }}
  {{- end }}
  {{- if hasKey .Values "command" }}
  command: ["/bin/sh", "-c"]
  args: ["$(command)"]
  {{- end }}
  {{- if hasKey .Values "readinessProbe" }}
  readinessProbe:
    httpGet:
      path: {{ .Values.readinessProbe.path }}
      port: {{ .Values.readinessProbe.port }}
    initialDelaySeconds: {{ .Values.readinessProbe.initialDelaySeconds | default 30 }}
    periodSeconds: {{ .Values.readinessProbe.periodSeconds | default 10 }}
    timeoutSeconds: {{ .Values.readinessProbe.timeoutSeconds | default 5 }}
    failureThreshold: {{ .Values.readinessProbe.failureThreshold | default 3 }}
  {{- end }}
  {{- if hasKey .Values "livenessProbe" }}
  livenessProbe:
    httpGet:
      path: {{ .Values.livenessProbe.path }}
      port: {{ .Values.livenessProbe.port }}
    initialDelaySeconds: 20
    periodSeconds: 10
  {{- end }}
  {{- if .Values.service }}
  {{- if .Values.service.enabled }}
  ports:
    {{- if hasKey .Values.service "targetPort" }}
    - containerPort: {{ .Values.service.targetPort }}
      protocol: TCP
    {{- else }}
    - containerPort: 80
      protocol: TCP
    {{- end }}
  {{- end }}
  {{- end }}
  volumeMounts:
    {{- if hasKey .Values "pvc" }}
      - name: {{ .Values.pvc.volumeName }}
        mountPath: {{ .Values.pvc.path }}
    {{- end }} 
{{- end }}
