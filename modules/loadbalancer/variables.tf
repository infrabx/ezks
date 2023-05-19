variable "albc_chart_version" {
  type        = string
  description = "Version to use of the AWS Load Balancer Controller chart "
}

variable "albc_role_name" {
  type        = string
  description = "The name to use for the AWS Load Balancer Controller IAM role"
  default     = "load-balancer-controller"
}

variable "albc_service_account_name" {
  type        = string
  description = "The name to use for the AWS Load Balancer Controller service account"
  default     = "aws-load-balancer-controller"
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "cluster_region" {
  type        = string
  description = "The region the cluster is located in"
}

variable "edns_chart_version" {
  type        = string
  description = "Version to use of the external DNS chart"
}

variable "edns_role_name" {
  type        = string
  description = "The name to use for the external DNS controller IAM role"
  default     = "external-dns"
}

variable "edns_service_account_name" {
  type        = string
  description = "The name to use for the external DNS controller service account"
  default     = "external-dns-controller"
}

variable "edns_zones" {
  type        = list(string)
  description = "A list of hosted zone ARNs to allow the external DNS controller to access"
}

variable "namespace" {
  type        = string
  description = "The namespace to deploy resources to"
  default     = "kube-system"
}

variable "oidc_provider_arn" {
  type        = string
  description = "The ARN of the cluster OIDC provider"
}

variable "label" {
  type = object({
    namespace   = optional(string)
    environment = optional(string)
    stage       = optional(string)
    name        = optional(string)
    attributes  = optional(list(string))
    delimiter   = optional(string)
    tags        = optional(map(string))
  })
  description = "The label to use for this module"
}
