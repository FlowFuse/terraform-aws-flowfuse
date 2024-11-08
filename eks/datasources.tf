data "aws_caller_identity" "current" {}

data "aws_iam_session_context" "current" {
  arn = data.aws_caller_identity.current.arn
}

data "aws_vpc" "this" {
  tags = {
    Namespace = var.namespace
    Stage     = var.stage
    Name      = "${var.namespace}-${var.stage}-flowfuse"
  }
}

data "aws_subnets" "private" {
  tags = {
    Attributes = "private"
    Namespace  = var.namespace
    Stage      = var.stage
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}

data "aws_subnets" "public" {
  tags = {
    Attributes = "public"
    Namespace  = var.namespace
    Stage      = var.stage
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
}

data "aws_security_group" "vpc_default_security_group_id" {
  vpc_id = data.aws_vpc.this.id
  name   = "default"
}

output "public_subnet_ids" {
  value = data.aws_subnets.public.ids
}

output "private_subnet_ids" {
  value = data.aws_subnets.private.ids
}
