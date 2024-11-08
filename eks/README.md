# Terraform EKS module

Terraform module which creates [FlowFuse-specific](https://flowfuse.com) [EKS](https://aws.amazon.com/eks/) cluster and node groups on AWS.

The module supports the following:

- Creation of an EKS cluster with configurable Kubernetes version.
- Management of EKS node groups, with support for multiple instance types, AMI types, and autoscaling configurations.
- Integration with AWS IAM for access control.
- Optional creation and management of related AWS resources such as IAM policies and roles.
- Support for enabling various EKS cluster features such as detailed monitoring and cluster autoscaling.

## Usage

`Replace AWS_ACCOUNT_ID with your AWS account ID`

```hcl
  module "eks" {
    source = "git::https://github.com/FlowFuse/terraform-aws-flowfuse.git//eks?ref=main"

    namespace = "my-company"
    stage     = "production"

    kubernetes_version           = "1.29"
    eks_access_entry_map         = {
      "arn:aws:iam::AWS_ACCOUNT_ID:user/your-user" = {
        access_policy_associations = {
          ClusterAdmin = {}
        }
      }
    }

    tags = {
      Environment = "production"
      Project = "my-project"
      terraform = true
    }
  }
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.48 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.48 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks_cluster"></a> [eks\_cluster](#module\_eks\_cluster) | cloudposse/eks-cluster/aws | 4.0.0 |
| <a name="module_node_groups"></a> [node\_groups](#module\_node\_groups) | cloudposse/eks-node-group/aws | 2.12.0 |
| <a name="module_vpc_cni_eks_iam_role"></a> [vpc\_cni\_eks\_iam\_role](#module\_vpc\_cni\_eks\_iam\_role) | cloudposse/eks-iam-role/aws | 2.1.1 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.vpc_cni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.vpc_cni_ipv6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_session_context.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_session_context) | data source |
| [aws_security_group.vpc_default_security_group_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_addons"></a> [addons](#input\_addons) | Manages [`aws_eks_addon`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) resources. | <pre>list(object({<br>    addon_name                  = string<br>    addon_version               = string<br>    resolve_conflicts           = optional(string, null)<br>    resolve_conflicts_on_create = optional(string, null)<br>    resolve_conflicts_on_update = optional(string, null)<br>    service_account_role_arn    = string<br>  }))</pre> | `[]` | no |
| <a name="input_cluster_log_retention_period"></a> [cluster\_log\_retention\_period](#input\_cluster\_log\_retention\_period) | The value in days for the retention period of the log group. | `number` | `14` | no |
| <a name="input_eks_access_entry_map"></a> [eks\_access\_entry\_map](#input\_eks\_access\_entry\_map) | Represents a map of access entries for an EKS cluster. Each entry in the map represents the access configuration for a specific principal ARN | <pre>map(object({<br>    # key is principal_arn<br>    user_name = optional(string)<br>    # Cannot assign "system:*" groups to IAM users, use ClusterAdmin and Admin instead<br>    kubernetes_groups = optional(list(string), [])<br>    type              = optional(string, "STANDARD")<br>    access_policy_associations = optional(map(object({<br>      # key is policy_arn or policy_name<br>      access_scope = optional(object({<br>        type       = optional(string, "cluster")<br>        namespaces = optional(list(string))<br>      }), {}) # access_scope<br>    })), {})  # access_policy_associations<br>  }))</pre> | `{}` | no |
| <a name="input_eks_node_groups"></a> [eks\_node\_groups](#input\_eks\_node\_groups) | Map of maps containing configuration of EKS node groups to be created. The key is the name of the node group.<br>    * `name` - Node Group name<br>    * `instance_types` - EC2 instance types to use for the node group<br>    * `ami_type` - AMI type for the instance<br>    * `desired_size` - desired number of instances<br>    * `min_size` - minimum number of instances<br>    * `max_size` - maximum number of instances<br>    * `kubernetes_version` - Kubernetes version for the node group<br>    * `kubernetes_labels` - Kubernetes labels to apply to the node group<br>    * `cluster_autoscaler_enabled` - whether to enable the cluster autoscaler for the node group<br>    * `detailed_monitoring_enabled` - whether to enable detailed monitoring for the node group<br>    * `attributes` - Additional attributes (e.g. `["eks"]`) | <pre>map(object({<br>    name                        = string<br>    instance_types              = list(string)<br>    ami_type                    = string<br>    desired_size                = number<br>    min_size                    = number<br>    max_size                    = number<br>    zone_ids                    = optional(list(string), null)<br>    kubernetes_version          = list(string)<br>    kubernetes_labels           = map(string)<br>    cluster_autoscaler_enabled  = bool<br>    detailed_monitoring_enabled = bool<br>    attributes                  = list(string)<br>  }))</pre> | <pre>{<br>  "management": {<br>    "ami_type": "AL2_x86_64",<br>    "attributes": [<br>      "management"<br>    ],<br>    "cluster_autoscaler_enabled": true,<br>    "desired_size": 1,<br>    "detailed_monitoring_enabled": false,<br>    "instance_types": [<br>      "m6a.xlarge"<br>    ],<br>    "kubernetes_labels": {<br>      "role": "management"<br>    },<br>    "kubernetes_version": [<br>      "1.26"<br>    ],<br>    "max_size": 2,<br>    "min_size": 1,<br>    "name": "management"<br>  },<br>  "projects": {<br>    "ami_type": "AL2_ARM_64",<br>    "attributes": [<br>      "projects"<br>    ],<br>    "cluster_autoscaler_enabled": true,<br>    "desired_size": 1,<br>    "detailed_monitoring_enabled": false,<br>    "instance_types": [<br>      "t4g.large"<br>    ],<br>    "kubernetes_labels": {<br>      "role": "projects"<br>    },<br>    "kubernetes_version": [<br>      "1.26"<br>    ],<br>    "max_size": 4,<br>    "min_size": 1,<br>    "name": "projects"<br>  }<br>}</pre> | no |
| <a name="input_eks_vpc_cni_addon_version"></a> [eks\_vpc\_cni\_addon\_version](#input\_eks\_vpc\_cni\_addon\_version) | The version of the VPC CNI addon to install on the EKS cluster | `string` | `"v1.18.0-eksbuild.1"` | no |
| <a name="input_enabled_cluster_log_types"></a> [enabled\_cluster\_log\_types](#input\_enabled\_cluster\_log\_types) | A list of the desired control plane logging to enable. Available values: api, audit, authenticator, controllerManager, scheduler | `list(string)` | <pre>[<br>  "api",<br>  "audit",<br>  "authenticator",<br>  "controllerManager",<br>  "scheduler"<br>]</pre> | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | The desired Kubernetes master version. If you do not specify a value, the latest available version is used. | `string` | `"1.26"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | n/a |
| <a name="output_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#output\_cluster\_oidc\_issuer\_url) | n/a |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | n/a |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | n/a |
<!-- END_TF_DOCS -->