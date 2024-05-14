# Terraform Route53 Module

This Terraform module is designed to manage [AWS Route53](https://aws.amazon.com/route53/) zone and associated [ACM certificates](https://aws.amazon.com/certificate-manager/).

The module supports the following:

- Creation of defined route53 zone
- Creation of certificate required to run FlowFuse self-hosted platform

The module also provides several outputs including the ACM certificate ARN and domain DNS records.

## Usage
```hcl
module "domain" {
  source = "git::https://github.com/flowFuse/terraform-aws-flowfuse.git//route53?ref=main"

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

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm_request_certificate"></a> [acm\_request\_certificate](#module\_acm\_request\_certificate) | cloudposse/acm-request-certificate/aws | 0.18.0 |
| <a name="module_zones"></a> [zones](#module\_zones) | terraform-aws-modules/route53/aws//modules/zones | ~> 2.11 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | n/a | yes |
| <a name="input_route53_zone_name"></a> [route53\_zone\_name](#input\_route53\_zone\_name) | The name of the Route53 zone to create | `string` | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acm_certificate_arn"></a> [acm\_certificate\_arn](#output\_acm\_certificate\_arn) | n/a |
| <a name="output_domain_dns_records"></a> [domain\_dns\_records](#output\_domain\_dns\_records) | n/a |
<!-- END_TF_DOCS -->