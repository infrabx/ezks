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

module "alb_controller_irsa_role" {
  # v5.9.2
  source = "github.com/terraform-aws-modules/terraform-aws-iam//modules/iam-role-for-service-accounts-eks?ref=cb074e72f38dd969e1a8dc5a1bdd0f647ab666cd"

  attach_load_balancer_controller_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["${var.namespace}:${var.albc_service_account_name}"]
    }
  }

  policy_name_prefix = "${module.label.id}-"
  role_name_prefix   = "${module.label.id}-albc-"
  role_description   = "Provides AWS access for Amazon Load Balancer Controller"

  tags = module.label.tags
}

module "alb_controller" {
  source = "./modules/alb_controller"

  cluster_name         = var.cluster_name
  cluster_region       = var.cluster_region
  service_account_name = var.albc_service_account_name
  chart_version        = var.albc_chart_version

  namespace = var.namespace
  role_arn  = module.alb_controller_irsa_role.iam_role_arn

  depends_on = [
    module.alb_controller_irsa_role
  ]
}

module "external_dns_irsa_role" {
  # v5.9.2
  source = "github.com/terraform-aws-modules/terraform-aws-iam//modules/iam-role-for-service-accounts-eks?ref=cb074e72f38dd969e1a8dc5a1bdd0f647ab666cd"

  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = var.edns_zones

  oidc_providers = {
    ex = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["${var.namespace}:${var.edns_service_account_name}"]
    }
  }

  policy_name_prefix = "${module.label.id}-"
  role_name_prefix   = "${module.label.id}-edns-"
  role_description   = "Provides AWS access for External DNS controller"

  tags = module.label.tags
}

module "external_dns" {
  source = "./modules/external_dns"

  id = module.label.id

  cluster_region       = var.cluster_region
  service_account_name = var.edns_service_account_name
  chart_version        = var.edns_chart_version

  namespace = var.namespace
  role_arn  = module.external_dns_irsa_role.iam_role_arn

  depends_on = [
    module.external_dns_irsa_role
  ]
}
