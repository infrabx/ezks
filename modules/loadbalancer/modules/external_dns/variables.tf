variable "cluster_region" {
  type        = string
  description = "The region the cluster is located in"
}

variable "chart_version" {
  type        = string
  description = "The chart version to use"
}

variable "id" {
  type        = string
  description = "Unique ID to identify this instance of external DNS"
}

variable "namespace" {
  type        = string
  description = "The namespace to deploy external-dns resources to"
  default     = "kube-system"
}

variable "role_arn" {
  type        = string
  description = "The ARN of the IAM role to use"
}

variable "service_account_name" {
  type        = string
  description = "The name to use for the AWS Load Balancer Controller service account"
  default     = "external-dns-controller"
}
