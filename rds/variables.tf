variable "namespace" {
  type        = string
  description = "ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique"
}

variable "stage" {
  type        = string
  description = "ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release'"
}

variable "cidr" {
  type        = string
  description = "The CIDR block for the RDS VPC"
  default     = "172.24.124.0/24"
}

variable "database_user" {
  type        = string
  description = "The master username for the database. Must be all lowercase"
  default     = "forge"
}

variable "database_name" {
  type        = string
  description = "The name of the database to create"
  default     = "flowforge"
}

variable "database_port" {
  type        = number
  description = "The port on which the database accepts connections"
  default     = 5432
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources"
  default     = {}
}