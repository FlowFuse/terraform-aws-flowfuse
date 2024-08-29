variable "namespace" {
  type        = string
  description = "ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique"
}

variable "stage" {
  type        = string
  description = "ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release'"
}

variable "route53_zone_name" {
  type        = string
  description = "The name of the Route53 zone"
}

variable "create_custom_domain_record" {
  type        = bool
  description = "Define if a custom domain record should be created"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources"
  default     = {}
}