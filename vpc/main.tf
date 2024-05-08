data "aws_availability_zones" "this" {
  all_availability_zones = false
  state                  = "available"
}

module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "2.2.0"

  namespace = var.namespace
  stage     = var.stage
  name      = "flowfuse"

  ipv4_primary_cidr_block = var.cidr

  assign_generated_ipv6_cidr_block = false
}

module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "2.4.2"

  namespace             = var.namespace
  stage                 = var.stage
  name                  = "flowfuse"
  vpc_id                = module.vpc.vpc_id
  igw_id                = [module.vpc.igw_id]
  ipv4_cidr_block       = [var.cidr]
  availability_zone_ids = data.aws_availability_zones.this.zone_ids
  max_subnet_count      = 3
  tags                  = var.tags
}
