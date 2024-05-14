# Terraform vpc-peering Module

This Terraform module sets up [VPC peering](https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html) between two VPCs in AWS. It creates a connection between VPC created with our [VPC](https://github.com/FlowFuse/terraform-aws-flowfuse/tree/main/vpc) and [RDS](https://github.com/FlowFuse/terraform-aws-flowfuse/tree/main/rds) modules. 
Additionally, it sets up the necessary routes to enable communication between the VPCs.

## Usage

```hcl
  module "peering" {
    source = "git::https://github.com/FlowFuse/terraform-aws-flowfuse.git//vpc-peering?ref=main"

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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.44.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc_peering"></a> [vpc\_peering](#module\_vpc\_peering) | cloudposse/vpc-peering/aws | 1.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_vpc.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->