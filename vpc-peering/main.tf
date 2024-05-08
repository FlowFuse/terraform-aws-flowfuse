module "vpc_peering" {
  source  = "cloudposse/vpc-peering/aws"
  version = "1.0.0"

  namespace                                 = var.namespace
  stage                                     = var.stage
  name                                      = "main-database-peering"
  requestor_vpc_id                          = data.aws_vpc.database.id
  acceptor_vpc_id                           = data.aws_vpc.main.id
  auto_accept                               = true
  requestor_allow_remote_vpc_dns_resolution = true
  acceptor_allow_remote_vpc_dns_resolution  = true
  create_timeout                            = "5m"
  update_timeout                            = "5m"
  delete_timeout                            = "10m"
}