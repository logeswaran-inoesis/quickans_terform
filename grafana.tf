resource "helm_release" "prometheus" {
  name       = "prometheus"
  namespace  = "monitoring"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = "25.21.0" # you can check for the latest version

  create_namespace = true

  values = [
    # Ensure persistent volume is enabled and configure storage class
    <<EOF
prometheus:
  server:
    persistentVolume:
      enabled: true
      size: 10Gi
      storageClass: "standard" # Change this to match the storage class in your cluster (e.g., "standard" for AWS or GCP)
  alertmanager:
    persistentVolume:
      enabled: true
      size: 10Gi
      storageClass: "standard" # Change this to match your storage class
EOF
  ]
}

resource "helm_release" "grafana" {
  name       = "grafana"
  namespace  = "monitoring"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "7.3.9"

  set {
    name  = "adminPassword"
    value = "admin123" # change this to something secure
  }

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  depends_on = [helm_release.prometheus]
}
