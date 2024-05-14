variable "namespace" {
  type        = string
  description = "ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique"
}

variable "stage" {
  type        = string
  description = "ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release'"
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
  description = "Represents a map of access entries for an EKS cluster. Each entry in the map represents the access configuration for a specific principal ARN"
  default     = {}
}

variable "kubernetes_version" {
  type        = string
  description = "The desired Kubernetes master version. If you do not specify a value, the latest available version is used."
  default     = "1.26"
}

variable "enabled_cluster_log_types" {
  type        = list(string)
  description = "A list of the desired control plane logging to enable. Available values: api, audit, authenticator, controllerManager, scheduler"
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "cluster_log_retention_period" {
  type        = number
  description = "The value in days for the retention period of the log group."
  default     = 14
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
  description = <<EOT
    Map of maps containing configuration of EKS node groups to be created. The key is the name of the node group.
    * `name` - Node Group name
    * `instance_types` - EC2 instance types to use for the node group
    * `ami_type` - AMI type for the instance
    * `desired_size` - desired number of instances
    * `min_size` - minimum number of instances
    * `max_size` - maximum number of instances
    * `kubernetes_labels` - Kubernetes labels to apply to the node group
    * `cluster_autoscaler_enabled` - whether to enable the cluster autoscaler for the node group
    * `detailed_monitoring_enabled` - whether to enable detailed monitoring for the node group
    * `attributes` - Additional attributes (e.g. `["eks"]`)
  EOT
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
variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources"
  default     = {}
}