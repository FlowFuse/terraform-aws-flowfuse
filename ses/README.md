# Terraform SES Module

This Terraform module sets up SES (Simple Email Service) related resources in AWS. It creates DNS records in Route53, IAM roles, and other necessary resources for SES to function properly.

## Usage

```hcl
  module "ses" {
    source = "git::https://github.com/FlowFuse/terraform-aws-flowfuse.git//ses?ref=main"

    namespace = "my-company"
    stage     = "production"

    route53_zone_name = "example.com"

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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.44.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dmarc_record"></a> [dmarc\_record](#module\_dmarc\_record) | terraform-aws-modules/route53/aws//modules/records | ~> 2.11 |
| <a name="module_eks_ses_iam_role"></a> [eks\_ses\_iam\_role](#module\_eks\_ses\_iam\_role) | cloudposse/eks-iam-role/aws | 2.1.1 |
| <a name="module_ses"></a> [ses](#module\_ses) | cloudposse/ses/aws | 0.25.0 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_iam_policy_document.ses](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | n/a | yes |
| <a name="input_route53_zone_name"></a> [route53\_zone\_name](#input\_route53\_zone\_name) | The name of the Route53 zone within which to create SES-related records | `string` | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_flowfuse_ses_role_arn"></a> [flowfuse\_ses\_role\_arn](#output\_flowfuse\_ses\_role\_arn) | n/a |
<!-- END_TF_DOCS -->