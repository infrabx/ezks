locals {
  policies = { for group, policies in var.policies : group =>
    flatten([
      for policy in policies : jsondecode(policy).Statement
    ])
  }
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
  for_each    = local.policies
  name        = "${module.label.id}-${each.key}"
  description = "Permissions for ${each.key} group access to ${var.environment} environment"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(each.value, [
      {
        Action = var.policy_templates.s3[var.permissions[each.key].policy]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${var.state_bucket}/${var.environment}/*"
        ]
      }
    ])
  })

  tags = module.label.tags
}

resource "aws_iam_group_policy_attachment" "this" {
  for_each   = local.policies
  group      = each.key
  policy_arn = aws_iam_policy.this[each.key].arn
}
