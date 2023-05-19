locals {
  zones = { for domain in var.domains : domain =>
    {
      tags = module.label.tags
    }
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

module "zones" {
  # v2.10.1
  source = "github.com/terraform-aws-modules/terraform-aws-route53//modules/zones?ref=4ef82dbca91a208fed022b84bf0d699f64358c3b"
  zones  = local.zones
  tags   = module.label.tags
}
