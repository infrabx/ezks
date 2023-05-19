output "zone_id" {
  description = "Zone IDs of Route53 zones"
  value       = module.zones.route53_zone_zone_id
}

output "zone_arn" {
  description = "Zone ARNs of Route53 zones"
  value       = module.zones.route53_zone_zone_arn
}

output "name_servers" {
  description = "Name servers of Route53 zones"
  value       = module.zones.route53_zone_name_servers
}

output "zone_name" {
  description = "Names of Route53 zones"
  value       = module.zones.route53_zone_name
}
