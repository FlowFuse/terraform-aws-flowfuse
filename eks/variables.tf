variable "namespace" {
  type = string
}

variable "stage" {
  type = string
}

variable "addons" {
  type = list(object({
    addon_name                  = string
    addon_version               = string
    resolve_conflicts           = optional(string, null)
    resolve_conflicts_on_create = optional(string, null)
    resolve_conflicts_on_update = optional(string, null)
    service_account_role_arn    = string
  }))
  default     = []
  description = "Manages [`aws_eks_addon`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) resources."
}

variable "eks_access_entry_map" {
  type = map(object({
    # key is principal_arn
    user_name = optional(string)
    # Cannot assign "system:*" groups to IAM users, use ClusterAdmin and Admin instead
    kubernetes_groups = optional(list(string), [])
    type              = optional(string, "STANDARD")
    access_policy_associations = optional(map(object({
      # key is policy_arn or policy_name
      access_scope = optional(object({
        type       = optional(string, "cluster")
        namespaces = optional(list(string))
      }), {}) # access_scope
    })), {})  # access_policy_associations
  }))
  default = {}
}

variable "kubernetes_version" {
  type    = string
  default = "1.26"
}

variable "enabled_cluster_log_types" {
  type    = list(string)
  default = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "cluster_log_retention_period" {
  type    = number
  default = 14
}

variable "instance_types" {
  type    = list(string)
  default = ["m6a.xlarge"]
}

variable "desired_size" {
  type    = number
  default = 1
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 2
}

variable "kubernetes_labels" {
  type = map(string)
  default = {
    terraform = "true"
  }
}

variable "cluster_autoscaler_enabled" {
  type    = bool
  default = true
}

variable "detailed_monitoring_enabled" {
  type    = bool
  default = false
}

variable "eks_node_groups" {
  type = map(object({
    name                        = string
    instance_types              = list(string)
    ami_type                    = string
    desired_size                = number
    min_size                    = number
    max_size                    = number
    kubernetes_labels           = map(string)
    cluster_autoscaler_enabled  = bool
    detailed_monitoring_enabled = bool
    attributes                  = list(string)
  }))
  default = {
    management = {
      name           = "management"
      instance_types = ["m6a.xlarge"]
      ami_type       = "AL2_x86_64"
      desired_size   = 1
      min_size       = 1
      max_size       = 2
      kubernetes_labels = {
        role = "management"
      }
      cluster_autoscaler_enabled  = true
      detailed_monitoring_enabled = false
      attributes                  = ["management"]
    },
    projects = {
      name           = "projects"
      instance_types = ["t4g.large"]
      ami_type       = "AL2_ARM_64"
      desired_size   = 1
      min_size       = 1
      max_size       = 4
      kubernetes_labels = {
        role = "projects"
      }
      cluster_autoscaler_enabled  = true
      detailed_monitoring_enabled = false
      attributes                  = ["projects"]
    },
  }
}

variable "route53_zone_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}