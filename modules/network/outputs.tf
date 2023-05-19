output "vpc" {
  description = "Outputs from the VPC module"
  value       = module.this
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.this.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.this.vpc_cidr_block
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.this.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.this.public_subnets
}

output "database_subnet_group" {
  description = "ID of database subnet group"
  value       = module.this.database_subnet_group
}
