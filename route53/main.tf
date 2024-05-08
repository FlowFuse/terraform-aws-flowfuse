module "zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 2.11"

  zones = {
    "${var.route53_zone_name}" = {
      comment       = "${var.namespace}-${var.stage}"
      force_destroy = true
      tags          = var.tags
    }
  }


  tags = var.tags
}

module "acm_request_certificate" {
  source  = "cloudposse/acm-request-certificate/aws"
  version = "0.18.0"

  domain_name                       = var.route53_zone_name
  zone_id                           = module.zones.route53_zone_zone_id[var.route53_zone_name]
  validation_method                 = "DNS"
  process_domain_validation_options = true
  ttl                               = "300"
  subject_alternative_names         = ["*.${var.route53_zone_name}"]
}
