data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.azs)
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


module "this" {
  # v3.18.1
  source = "github.com/terraform-aws-modules/terraform-aws-vpc?ref=aa61bc4346e1c430df8ec163ae9799d57df4af20"

  name = module.label.id

  cidr = var.cidr
  azs  = local.azs

  public_subnets   = [for k, v in local.azs : cidrsubnet(var.cidr, var.subnet_bits, k)]
  private_subnets  = [for k, v in local.azs : cidrsubnet(var.cidr, var.subnet_bits, k + 10)]
  database_subnets = [for k, v in local.azs : cidrsubnet(var.cidr, var.subnet_bits, k + 20)]

  enable_nat_gateway = true

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  tags = module.label.tags
}
