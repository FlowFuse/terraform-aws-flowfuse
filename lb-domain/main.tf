data "aws_lb" "ingress" {
  tags = {
    Namespace = var.namespace
    Stage     = var.stage
  }
}

data "aws_lb" "custom_domains_ingress" {
  count = var.create_custom_domain_record ? 1 : 0
  tags = {
    Namespace     = var.namespace
    Stage         = var.stage
    custom_domains= "true"
  }
}

locals {
  main_dns_records = [
    {
      name = "*"
      type = "CNAME"
      ttl  = 300
      records = [
        data.aws_lb.ingress.dns_name
      ]
    }
  ]

  custom_domain_dns_record = var.create_custom_domain_record ? {
      name = var.custom_domain_record_value
      type = "CNAME"
      ttl  = 300
      records = [
        data.aws_lb.custom_domains_ingress.0.dns_name
      ]
    } : null

  dns_records = concat(
    local.main_dns_records,
    var.create_custom_domain_record ? [ local.custom_domain_dns_record ] : []
  )
}


module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.11"

  zone_name = var.route53_zone_name

  records = local.dns_records
}
