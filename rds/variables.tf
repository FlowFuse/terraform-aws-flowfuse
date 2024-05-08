variable "namespace" {
  type = string
}

variable "stage" {
  type = string
}

variable "cidr" {
  type    = string
  default = "172.24.124.0/24"
}

variable "database_user" {
  type    = string
  default = "forge"
}

variable "database_name" {
  type    = string
  default = "flowforge"
}

variable "database_port" {
  type    = number
  default = 5432
}

variable "tags" {
  type    = map(string)
  default = {}
}