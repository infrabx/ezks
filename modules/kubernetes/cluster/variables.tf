variable "cluster_desired_size" {
  type        = number
  description = "Desired number of instances/nodes"
  default     = 1
}

variable "cluser_max_size" {
  type        = number
  description = "Maximum number of instances/nodes"
  default     = 3
}

variable "cluster_min_size" {
  type        = number
  description = "Minimum number of instances/nodes"
  default     = 1
}

variable "cluster_version" {
  type        = string
  description = "Version of the cluster"
}

variable "instance_capacity_type" {
  type        = string
  description = "The type of instances to use (either ON_DEMAND or SPOT)"
  default     = "ON_DEMAND"
}

variable "instance_types" {
  type        = list(string)
  description = "List of instance types associated with the EKS Node"
  default     = ["t2.medium", "t3.medium"]
}

variable "node_disk_size" {
  type        = number
  description = "Disk size in GiB for nodes"
  default     = 50
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnet IDs to use for the cluster"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC to use for the cluster"
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
