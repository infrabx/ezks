variable "groups" {
  type        = any
  description = "A map of groups to their respective policies"
}

variable "users" {
  type        = any
  description = "A map of users to their PGP keys"
}

variable "common_policies" {
  type        = any
  description = "A list of policies to include in a common policy and attach to all groups"
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
