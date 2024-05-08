output "domain_dns_records" {
  value = module.zones.route53_zone_name_servers[var.route53_zone_name]
}

output "acm_certificate_arn" {
  value = module.acm_request_certificate.arn
}
