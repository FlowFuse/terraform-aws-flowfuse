data "aws_availability_zones" "this" {
  all_availability_zones = false
  state                  = "available"
}

module "rds_vpc" {
  source  = "cloudposse/vpc/aws"
  version = "2.2.0"

  namespace                        = var.namespace
  stage                            = var.stage
  name                             = "flowfuse-db"
  ipv4_primary_cidr_block          = var.cidr
  assign_generated_ipv6_cidr_block = false

  tags = var.tags
}

module "rds_subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "2.4.2"

  namespace              = var.namespace
  stage                  = var.stage
  name                   = "flowfuse-db"
  vpc_id                 = module.rds_vpc.vpc_id
  igw_id                 = [module.rds_vpc.igw_id]
  ipv4_cidr_block        = [var.cidr]
  availability_zone_ids  = data.aws_availability_zones.this.zone_ids
  public_subnets_enabled = false
  max_subnet_count       = 3
  nat_gateway_enabled    = false
  nat_instance_enabled   = false

  tags = var.tags
}

data "aws_vpc" "this" {
  tags = {
    Namespace = var.namespace
    Stage     = var.stage
    Name      = "${var.namespace}-${var.stage}-flowfuse"
  }
}

module "primary" {
  source  = "cloudposse/rds/aws"
  version = "1.1.2"

  namespace = var.namespace
  stage     = var.stage
  name      = "flowfuse"
  host_name = "db"
  # security_group_ids = [data.aws_vpc.this.cidr_block]
  ca_cert_identifier                    = "rds-ca-ecc384-g1"
  allowed_cidr_blocks                   = [data.aws_vpc.this.cidr_block]
  database_name                         = var.database_name
  database_user                         = var.database_user
  database_password                     = random_password.database_password.result
  database_port                         = var.database_port
  multi_az                              = false
  storage_type                          = "gp2"
  allocated_storage                     = 10
  storage_encrypted                     = true
  engine                                = "postgres"
  engine_version                        = "14.10"
  major_engine_version                  = "14"
  instance_class                        = "db.t4g.small"
  db_parameter_group                    = "postgres14"
  publicly_accessible                   = false
  vpc_id                                = module.rds_vpc.vpc_id
  subnet_ids                            = module.rds_subnets.private_subnet_ids
  auto_minor_version_upgrade            = false
  allow_major_version_upgrade           = false
  apply_immediately                     = false
  maintenance_window                    = "Mon:03:00-Mon:04:00"
  skip_final_snapshot                   = true
  copy_tags_to_snapshot                 = true
  backup_retention_period               = 7
  backup_window                         = "00:52-01:52"
  deletion_protection                   = false
  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  tags                                  = var.tags

}

resource "random_password" "database_password" {
  length           = 24
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

module "replica" {
  source  = "cloudposse/rds/aws"
  version = "1.1.0"
  enabled = true

  namespace                   = var.namespace
  stage                       = var.stage
  name                        = "flowfuse-replica"
  replicate_source_db         = module.primary.instance_id
  host_name                   = "db"
  security_group_ids          = [module.rds_vpc.vpc_default_security_group_id]
  ca_cert_identifier          = "rds-ca-ecc384-g1"
  database_port               = var.database_port
  multi_az                    = false
  storage_type                = "gp2"
  storage_encrypted           = true
  engine                      = "postgres"
  engine_version              = "14.10"
  major_engine_version        = "14"
  instance_class              = "db.t4g.micro"
  db_parameter_group          = "postgres14"
  publicly_accessible         = false
  vpc_id                      = module.rds_vpc.vpc_id
  subnet_ids                  = module.rds_subnets.private_subnet_ids
  auto_minor_version_upgrade  = false
  allow_major_version_upgrade = false
  apply_immediately           = false
  maintenance_window          = "Mon:03:00-Mon:04:00"
  skip_final_snapshot         = true
  copy_tags_to_snapshot       = true
  backup_retention_period     = 3
  backup_window               = "02:00-03:00"
  deletion_protection         = false
  tags                        = var.tags
}
