data "aws_lb" "ingress" {
  tags = {
    Namespace = var.namespace
    Stage     = var.stage
  }
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.11"

  zone_name = var.route53_zone_name

  records = [
    {
      name = "*"
      type = "CNAME"
      ttl  = 300
      records = [
        data.aws_lb.ingress.dns_name
      ]
    }
  ]
}
