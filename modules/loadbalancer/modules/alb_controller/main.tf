locals {
  # Source: https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
  ecr_map = {
    af-south-1     = "877085696533.dkr.ecr.af-south-1.amazonaws.com"
    ap-east-1      = "800184023465.dkr.ecr.ap-east-1.amazonaws.com"
    ap-northeast-1 = "602401143452.dkr.ecr.ap-northeast-1.amazonaws.com"
    ap-northeast-2 = "602401143452.dkr.ecr.ap-northeast-2.amazonaws.com"
    ap-northeast-3 = "602401143452.dkr.ecr.ap-northeast-3.amazonaws.com"
    ap-south-1     = "602401143452.dkr.ecr.ap-south-1.amazonaws.com"
    ap-southeast-1 = "602401143452.dkr.ecr.ap-southeast-1.amazonaws.com"
    ap-southeast-2 = "602401143452.dkr.ecr.ap-southeast-2.amazonaws.com"
    ap-southeast-3 = "296578399912.dkr.ecr.ap-southeast-3.amazonaws.com"
    ca-central-1   = "602401143452.dkr.ecr.ca-central-1.amazonaws.com"
    cn-north-1     = "918309763551.dkr.ecr.cn-north-1.amazonaws.com.cn"
    cn-northwest-1 = "961992271922.dkr.ecr.cn-northwest-1.amazonaws.com.cn"
    eu-central-1   = "602401143452.dkr.ecr.eu-central-1.amazonaws.com"
    eu-north-1     = "602401143452.dkr.ecr.eu-north-1.amazonaws.com"
    eu-south-1     = "590381155156.dkr.ecr.eu-south-1.amazonaws.com"
    eu-west-1      = "602401143452.dkr.ecr.eu-west-1.amazonaws.com"
    eu-west-2      = "602401143452.dkr.ecr.eu-west-2.amazonaws.com"
    eu-west-3      = "602401143452.dkr.ecr.eu-west-3.amazonaws.com"
    me-south-1     = "558608220178.dkr.ecr.me-south-1.amazonaws.com"
    me-central-1   = "759879836304.dkr.ecr.me-central-1.amazonaws.com"
    sa-east-1      = "602401143452.dkr.ecr.sa-east-1.amazonaws.com"
    us-east-1      = "602401143452.dkr.ecr.us-east-1.amazonaws.com"
    us-east-2      = "602401143452.dkr.ecr.us-east-2.amazonaws.com"
    us-gov-east-1  = "151742754352.dkr.ecr.us-gov-east-1.amazonaws.com"
    us-gov-west-1  = "013241004608.dkr.ecr.us-gov-west-1.amazonaws.com"
    us-west-1      = "602401143452.dkr.ecr.us-west-1.amazonaws.com"
    us-west-2      = "602401143452.dkr.ecr.us-west-2.amazonaws.com"
  }
}

resource "kubernetes_service_account" "aws-load-balancer-controller" {
  metadata {
    name      = var.service_account_name
    namespace = var.namespace

    labels = {
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/name"      = var.service_account_name
    }

    annotations = {
      "eks.amazonaws.com/role-arn" = var.role_arn
    }
  }
  automount_service_account_token = true
}

resource "helm_release" "aws-load-balancer-controller" {
  name       = "aws-load-balancer-controller"
  namespace  = kubernetes_service_account.aws-load-balancer-controller.metadata.0.namespace
  wait       = true
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = var.chart_version

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "image.repository"
    value = "${local.ecr_map[var.cluster_region]}/amazon/aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.aws-load-balancer-controller.metadata.0.name
  }

  depends_on = [
    kubernetes_service_account.aws-load-balancer-controller
  ]
}
