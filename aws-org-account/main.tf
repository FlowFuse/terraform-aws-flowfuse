module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  name       = "ffd"
  namespace  = var.namespace
  stage      = var.stage
  attributes = var.attributes

  tags = var.tags
}

resource "aws_organizations_account" "account" {
  name              = module.label.id
  email             = "${module.label.id_full}@flowfuse.com"
  close_on_deletion = var.close_account_on_delete
}


resource "aws_iam_group" "default" {
  name = module.label.id

}

resource "aws_iam_group_membership" "default" {
  name  = "${aws_iam_group.default.name}-membership"
  group = aws_iam_group.default.name
  users = var.user_names
}

data "aws_iam_policy_document" "default" {

  statement {
    actions = [
      "sts:AssumeRole",
    ]

    resources = ["arn:aws:iam::${aws_organizations_account.account.id}:role/OrganizationAccountAccessRole"]

    effect = "Allow"
  }
}

resource "aws_iam_group_policy" "this" {
  name   = module.label.id
  group  = aws_iam_group.default.id
  policy = data.aws_iam_policy_document.default.json
}
