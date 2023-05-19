locals {
  users_to_groups = transpose({ for group, details in data.aws_iam_group.this : group => details.users.*.arn })
  users_to_roles  = { for user, group in local.users_to_groups : user => var.group_map[group[0]] }
  users_map = [for user, roles in local.users_to_roles : {
    userarn  = user
    username = split("/", user)[1]
    groups   = roles
  }]
  roles_map = [for aws_role, kube_roles in var.role_map : {
    rolearn  = aws_role
    username = split("/", aws_role)[1]
    groups   = kube_roles
  }]
}

data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "aws_iam_group" "this" {
  for_each   = var.permissions
  group_name = each.key
}

module "label" {
  # v0.25.0
  source = "github.com/cloudposse/terraform-null-label?ref=488ab91e34a24a86957e397d9f7262ec5925586a"

  namespace   = var.label.namespace
  environment = var.label.environment
  stage       = var.label.stage
  name        = var.label.name
  attributes  = var.label.attributes
  delimiter   = var.label.delimiter
  tags        = var.label.tags
}


resource "aws_iam_policy" "this" {
  for_each    = var.permissions
  name        = "${var.cluster_name}-${each.key}-permissions"
  description = "Permissions for ${each.key} group access to ${var.cluster_name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = var.policy_templates.eks[each.value.policy]
        Effect   = "Allow"
        Resource = data.aws_eks_cluster.this.arn
      },
    ]
  })

  tags = module.label.tags
}

resource "kubernetes_config_map_v1_data" "this" {
  force = true

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode(concat([
      {
        groups = [
          "system:bootstrappers",
          "system:nodes"
        ]
        rolearn  = var.cluster_node_arn
        username = "system:node:{{EC2PrivateDNSName}}"
      }
    ], local.roles_map))
    mapUsers = yamlencode(local.users_map)
  }
}
