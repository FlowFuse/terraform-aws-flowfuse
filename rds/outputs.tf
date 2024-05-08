output "database_address" {
  value = module.primary.instance_address
}

output "database_user" {
  value = var.database_user
}

output "database_password" {
  value     = random_password.database_password.result
  sensitive = true
}

output "database_name" {
  value = var.database_name
}
