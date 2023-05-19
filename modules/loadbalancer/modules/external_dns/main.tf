resource "kubernetes_service_account" "external_dns" {
  metadata {
    name      = var.service_account_name
    namespace = var.namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = var.role_arn
    }
  }
  automount_service_account_token = true
}

resource "kubernetes_cluster_role" "external_dns" {
  metadata {
    name = "external-dns"
  }

  rule {
    api_groups = [""]
    resources  = ["services", "pods", "nodes"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["extensions", "networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["networking.istio.io"]
    resources  = ["gateways"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["endpoints"]
    verbs      = ["get", "watch", "list"]
  }
}

resource "kubernetes_cluster_role_binding" "external_dns" {
  metadata {
    name = "external-dns"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.external_dns.metadata.0.name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.external_dns.metadata.0.name
    namespace = kubernetes_service_account.external_dns.metadata.0.namespace
  }
}

resource "helm_release" "external_dns" {
  name       = "external-dns"
  namespace  = kubernetes_service_account.external_dns.metadata.0.namespace
  wait       = true
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = var.chart_version

  set {
    name  = "rbac.create"
    value = false
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.external_dns.metadata.0.name
  }

  set {
    name  = "rbac.pspEnabled"
    value = false
  }

  set {
    name  = "name"
    value = "external-dns"
  }

  set {
    name  = "provider"
    value = "aws"
  }

  set {
    name  = "policy"
    value = "sync"
  }

  set {
    name  = "logLevel"
    value = "warning"
  }

  set {
    name  = "sources"
    value = "{ingress,service}"
  }

  set {
    name  = "aws.zoneType"
    value = "public"
  }

  set {
    name  = "aws.region"
    value = var.cluster_region
  }

  set {
    name  = "txtOwnerId"
    value = var.id
  }

  depends_on = [
    kubernetes_service_account.external_dns
  ]
}
