variable "azs" {
  type        = number
  description = "The number of availability zones to use (one subnet per az is created)"
}

variable "cidr" {
  type        = string
  description = "The CIDR block to use for the VPC"
}

variable "subnet_bits" {
  type        = number
  description = "Number of bits to augment the CIDR with for creating subnets"
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
