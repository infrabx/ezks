variable "environment" {
  type        = string
  description = "The name of the environment to scope secret access to"
}

variable "permissions" {
  type        = any
  description = "A map of group names to their respective permissions"
}

variable "policies" {
  type        = any
  description = "A mapping of groups to their respective policies"
}

variable "state_bucket" {
  type        = string
  description = "The name of the S3 bucket holding Terraform state"
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
