locals {
  # enabled = module.this.enabled

  # private_ipv6_enabled = var.private_ipv6_enabled

  # The usage of the specific kubernetes.io/cluster/* resource tags below are required
  # for EKS and Kubernetes to discover and manage networking resources
  # https://aws.amazon.com/premiumsupport/knowledge-center/eks-vpc-subnet-discovery/
  # https://github.com/kubernetes-sigs/aws-load-balancer-controller/blob/main/docs/deploy/subnet_discovery.md
  # tags = { "kubernetes.io/cluster/${module.label.id}" = "shared" }



  # Enable the IAM user creating the cluster to administer it,
  # without using the bootstrap_cluster_creator_admin_permissions option,
  # as a way to test the access_entry_map feature.
  # In general, this is not recommended. Instead, you should
  # create the access_entry_map statically, with the ARNs you want to
  # have access to the cluster. We do it dynamically here just for testing purposes.
  # access_entry_map = {
  #   (data.aws_iam_session_context.current.issuer_arn) = {
  #     access_policy_associations = {
  #       ClusterAdmin = {}
  #     }
  #   }
  # }

  # https://docs.aws.amazon.com/eks/latest/userguide/managing-vpc-cni.html#vpc-cni-latest-available-version
  vpc_cni_addon = {
    addon_name               = "vpc-cni"
    addon_version            = "v1.18.0-eksbuild.1"
    resolve_conflicts        = "OVERWRITE"
    service_account_role_arn = one(module.vpc_cni_eks_iam_role[*].service_account_role_arn)
  }

  addons = concat([
    local.vpc_cni_addon
  ], var.addons)
}

module "eks_cluster" {
  source  = "cloudposse/eks-cluster/aws"
  version = "4.0.0"

  name                         = "flowfuse"
  namespace                    = var.namespace
  stage                        = var.stage
  subnet_ids                   = concat(data.aws_subnets.private.ids, data.aws_subnets.public.ids)
  kubernetes_version           = var.kubernetes_version
  oidc_provider_enabled        = true
  enabled_cluster_log_types    = var.enabled_cluster_log_types
  cluster_log_retention_period = var.cluster_log_retention_period

  addons            = local.addons
  addons_depends_on = [module.node_groups]

  access_entry_map = var.eks_access_entry_map

  access_config = {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = false
  }

  # This is to test `allowed_security_group_ids` and `allowed_cidr_blocks`
  # In a real cluster, these should be some other (existing) Security Groups and CIDR blocks to allow access to the cluster
  allowed_security_group_ids = [data.aws_security_group.vpc_default_security_group_id.id]
  allowed_cidr_blocks        = [data.aws_vpc.this.cidr_block]

  # kubernetes_network_ipv6_enabled = local.private_ipv6_enabled

  # context = module.this.context

}

module "node_groups" {
  source  = "cloudposse/eks-node-group/aws"
  version = "2.12.0"

  for_each                    = var.eks_node_groups
  subnet_ids                  = data.aws_subnets.private.ids
  cluster_name                = module.eks_cluster.eks_cluster_id
  kubernetes_version          = [var.kubernetes_version]
  instance_types              = each.value.instance_types
  ami_type                    = each.value.ami_type
  desired_size                = each.value.desired_size
  min_size                    = each.value.min_size
  max_size                    = each.value.max_size
  kubernetes_labels           = each.value.kubernetes_labels
  cluster_autoscaler_enabled  = each.value.cluster_autoscaler_enabled
  detailed_monitoring_enabled = each.value.detailed_monitoring_enabled
  namespace                   = var.namespace
  environment                 = "prod"
  stage                       = var.stage
  attributes                  = each.value.attributes
  node_role_policy_arns       = [aws_iam_policy.cluster_autoscaler.arn]
}
