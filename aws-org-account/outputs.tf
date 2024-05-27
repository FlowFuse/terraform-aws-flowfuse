output "role_arn" {
  value = "arn:aws:iam::${aws_organizations_account.account.id}:role/OrganizationAccountAccessRole"
}