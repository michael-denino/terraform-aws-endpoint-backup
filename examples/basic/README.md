# Endpoint Backup Module Basic Example
Provides a basic usage example for the endpoint backup module.

## Table of Contents
- [Overview](#overview)
- [Terraform Docs](#terraform-docs)
  - [Requirements](#requirements)
  - [Providers](#providers)
  - [Modules](#modules)
  - [Resources](#resources)
  - [Inputs](#inputs)
  - [Outputs](#outputs)

## Overview
Example module call sets a custom bucket name, custom IAM user name, and creates IAM user access keys which are stored in the state file. Object locking is enabled. State file should be encrypted and stored in a secure backend when enabling Access key creation without PGP encryption.

## Terraform Docs
The following documentation is automatically generated by `terraform-docs`. Refer to the module files for configuration details.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_endpoint_backup_example"></a> [endpoint\_backup\_example](#module\_endpoint\_backup\_example) | ../../ | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_key_create_date"></a> [access\_key\_create\_date](#output\_access\_key\_create\_date) | Date and time in RFC3339 format that IAM user access key was created |
| <a name="output_access_key_id"></a> [access\_key\_id](#output\_access\_key\_id) | IAM user access key id |
| <a name="output_iam_user_arn"></a> [iam\_user\_arn](#output\_iam\_user\_arn) | IAM user ARN |
| <a name="output_iam_user_name"></a> [iam\_user\_name](#output\_iam\_user\_name) | IAM user name |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | S3 bucket ARN |
| <a name="output_s3_bucket_name"></a> [s3\_bucket\_name](#output\_s3\_bucket\_name) | S3 bucket name |
| <a name="output_secret_access_key"></a> [secret\_access\_key](#output\_secret\_access\_key) | IAM user secret access key |
<!-- END_TF_DOCS -->
