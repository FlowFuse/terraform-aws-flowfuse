output "cluster_name" {
  value = module.eks_cluster.eks_cluster_id
}

output "cluster_oidc_issuer_url" {
  value = module.eks_cluster.eks_cluster_identity_oidc_issuer
}

output "application_iam_role_name" {
  value = module.eks_ses_iam_role.service_account_role_name
}
