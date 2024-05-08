variable "namespace" {
  type = string
}

variable "stage" {
  type = string
}

variable "route53_zone_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}