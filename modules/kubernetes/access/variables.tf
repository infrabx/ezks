variable "cluster_name" {
  type        = string
  description = "The name of the cluster to configure permissions for"
}

variable "cluster_node_arn" {
  type        = string
  description = "The ARN of the default cluster node group role"
}

variable "group_map" {
  type        = any
  description = "A map of group names to their respective cluster roles"
}

variable "role_map" {
  type        = any
  description = "A map of IAM roles to their respective cluster roles"
}

variable "permissions" {
  type        = any
  description = "A map of group names to their respective permissions"
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

variable "policy_templates" {
  type        = any
  description = "A map of common policy templates to use"
}
