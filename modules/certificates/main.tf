locals {
  root_domains = [for root, sub in var.domains : root]
  domains = merge(
    [for root in local.root_domains :
      { for sub in var.domains[root] : sub => data.aws_route53_zone.zones[root].zone_id }
    ]...
  )
}

data "aws_route53_zone" "zones" {
  for_each = var.domains
  name     = each.key
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

module "acm" {
  # v4.3.1
  source = "github.com/terraform-aws-modules/terraform-aws-acm?ref=47fc8a80c3f87150f685c68f710b9a9c8e4b9a50"

  for_each = local.domains

  domain_name = each.key
  zone_id     = each.value

  wait_for_validation = true

  tags = module.label.tags
}
