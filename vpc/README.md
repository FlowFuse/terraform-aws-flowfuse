# Terraform VPC Module

The VPC module is responsible for creating a Virtual Private Cloud (VPC) in AWS. It provisions the necessary resources such as subnets and availability zones.

## Usage

```hcl
  module "vpc" {
    source = "git::https://github.com/FlowFuse/terraform-aws-flowfuse.git//vpc?ref=main"

    namespace = "my-company"
    stage     = "production"

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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.42.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_subnets"></a> [subnets](#module\_subnets) | cloudposse/dynamic-subnets/aws | 2.4.2 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | cloudposse/vpc/aws | 2.2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_availability_zones.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr"></a> [cidr](#input\_cidr) | The CIDR block for the VPC. | `string` | `"10.0.0.0/16"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->