data "aws_vpc" "main" {
  tags = {
    Namespace = var.namespace
    Stage     = var.stage
    Name      = "${var.namespace}-${var.stage}-flowfuse"
  }
}

data "aws_vpc" "database" {
  tags = {
    Namespace = var.namespace
    Stage     = var.stage
    Name      = "${var.namespace}-${var.stage}-flowfuse-db"
  }
}