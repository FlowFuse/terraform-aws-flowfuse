data "aws_route53_zone" "selected" {
  name         = var.route53_zone_name
  private_zone = false
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_eks_cluster" "this" {
  name = "${var.namespace}-${var.stage}-flowfuse-cluster"
}

module "ses" {
  source  = "cloudposse/ses/aws"
  version = "0.25.0"

  namespace = var.namespace
  stage     = var.stage

  domain            = var.route53_zone_name
  zone_id           = data.aws_route53_zone.selected.zone_id
  verify_dkim       = true
  verify_domain     = true
  create_spf_record = true
  ses_group_enabled = false
  ses_user_enabled  = false
}

module "dmarc_record" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.11"

  zone_name = var.route53_zone_name

  records = [
    {
      name = "_dmarc"
      type = "TXT"
      ttl  = 300
      records = [
        "v=DMARC1;p=quarantine;pct=75;rua=mailto:noreply@${var.route53_zone_name}"
      ]
    }
  ]
}

module "eks_ses_iam_role" {
  source  = "cloudposse/eks-iam-role/aws"
  version = "2.1.1"

  namespace = var.namespace
  stage     = var.stage

  aws_account_number          = one(data.aws_caller_identity.current[*].account_id)
  eks_cluster_oidc_issuer_url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer

  service_account_name      = "flowforge"
  service_account_namespace = "default"
  aws_iam_policy_document   = [data.aws_iam_policy_document.ses.json]
}

data "aws_iam_policy_document" "ses" {
  statement {
    sid    = "AllowToSendEmailsViaSes"
    effect = "Allow"
    resources = [format("arn:aws:ses:%s:%s:identity/*", data.aws_region.current.name, one(data.aws_caller_identity.current[*].account_id))]
    actions = [
      "ses:SendEmail",
      "ses:SendTemplatedEmail",
      "ses:SendRawEmail"
    ]
  }
}
