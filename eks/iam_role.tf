module "flowfuse_iam_role" {
  source  = "cloudposse/eks-iam-role/aws"
  version = "2.2.1"

  namespace = var.namespace
  stage     = var.stage

  aws_account_number          = one(data.aws_caller_identity.current[*].account_id)
  eks_cluster_oidc_issuer_url = module.eks_cluster.eks_cluster_identity_oidc_issuer

  service_account_name      = "flowforge"
  service_account_namespace = "default"
}

