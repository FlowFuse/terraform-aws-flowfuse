# 

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.48 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.44.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_primary"></a> [primary](#module\_primary) | cloudposse/rds/aws | 1.1.0 |
| <a name="module_rds_subnets"></a> [rds\_subnets](#module\_rds\_subnets) | cloudposse/dynamic-subnets/aws | 2.4.2 |
| <a name="module_rds_vpc"></a> [rds\_vpc](#module\_rds\_vpc) | cloudposse/vpc/aws | 2.2.0 |
| <a name="module_replica"></a> [replica](#module\_replica) | cloudposse/rds/aws | 1.1.0 |

## Resources

| Name | Type |
|------|------|
| [random_password.database_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_availability_zones.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr"></a> [cidr](#input\_cidr) | The CIDR block for the RDS VPC | `string` | `"172.24.124.0/24"` | no |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | The name of the database to create | `string` | `"flowforge"` | no |
| <a name="input_database_port"></a> [database\_port](#input\_database\_port) | The port on which the database accepts connections | `number` | `5432` | no |
| <a name="input_database_user"></a> [database\_user](#input\_database\_user) | The master username for the database. Must be all lowercase | `string` | `"forge"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database_address"></a> [database\_address](#output\_database\_address) | n/a |
| <a name="output_database_name"></a> [database\_name](#output\_database\_name) | n/a |
| <a name="output_database_password"></a> [database\_password](#output\_database\_password) | n/a |
| <a name="output_database_user"></a> [database\_user](#output\_database\_user) | n/a |
<!-- END_TF_DOCS -->