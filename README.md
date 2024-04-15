# Terraform AWS Endpoint Backup
Terraform AWS module to create the S3 and IAM resources needed for endpoint backup software such as [Arq](https://www.arqbackup.com/index.html), and [MSP360 Standalone Backup](https://www.msp360.com/cloudberry-products/) (Formerly CloudBerry Backup).

## Table of Contents
- [Overview](#overview)
- [Usage](#usage)
- [S3 Bucket](#s3-bucket)
  - [Server Access Logging](#server-access-logging)
  - [Object Locking](#object-locking)
  - [Server-Side Encryption](#server-side-encryption)
  - [Bucket Policy](#bucket-policy)
- [IAM Credentials](#iam-credentials)
  - [Out of Band Key Generation](#out-of-band-key-generation)
  - [Terraform Key Generation](#terraform-key-generation)
  - [Terraform Key Generation with PGP Encryption](#terraform-key-generation-with-pgp-encryption)
- [Terraform Docs](#terraform-docs)
  - [Requirements](#requirements)
  - [Providers](#providers)
  - [Modules](#modules)
  - [Resources](#resources)
  - [Inputs](#inputs)
  - [Outputs](#outputs)

## Overview
This AWS Terraform module creates secure infrastructure to backup workstations and on-premise servers. This module is compatible with endpoint backup software such as [Arq](https://www.arqbackup.com/index.html), [MSP360 Standalone Backup](https://www.msp360.com/cloudberry-products/) (Formerly CloudBerry Backup), and other solutions that integrate with AWS S3. This infrastructure is also compatible with [CloudBerry Explorer](https://www.msp360.com/explorer/mac/), which allows mounting S3 as a remote drive. This module is not affiliated with any backup software.

## Usage
This module provides a default configuration that does not require inputs.
```hcl
module "endpoint_backup_test" {
  source  = "michael-denino/endpoint-backup/aws"
  version = "1.0.1"
}
```

An example module call using inputs is shown below. Refer to the [Inputs](#inputs) section for a complete list of inputs.
```hcl
module "endpoint_backup_test" {
  source                = "michael-denino/endpoint-backup/aws"
  version               = "1.0.1"
  bucket_name           = "example-backup"
  transfer_acceleration = "Enabled"
  object_lock_enabled   = true
  create_access_keys    = true
  iam_username          = ["example-user"]
```

Refer to the `./examples` directory for additional usage examples.

## S3 Bucket
This module creates an S3 bucket for use as an backup storage location. The bucket is configured for private access only. This module offers several features which can be enabled such as server access logging, object locking, KMS server-side encryption, and transfer acceleration. Refer to the [inputs](#inputs) section for more information.

### Server Access Logging
Configure S3 bucket server access logging using an input parameter. A log destination bucket in the same region as the backup bucket is required to store server access logs. Using the same bucket for both the log source and destination creates an infinite loop. Refer to the [logging requests with server access logging](https://docs.aws.amazon.com/AmazonS3/latest/userguide/ServerLogs.html?icmpid=docs_amazons3_console) AWS documentation for more information.

### Object Locking
If bucket object locking is desired, it must be enabled via input parameter at the time of bucket creation. If object locking is enabled after bucket creation, it will force the recreation of the resource.

### Server-Side Encryption
AES256 server-side encryption is enabled by default. KMS encryption can be enabled via input parameter.

### Bucket Policy
The bucket policy requires all bucket communications use TLS 1.2 or greater and limits compliance mode object locks to a specified duration.

The object lock restriction does not apply to objects locks using governance mode.

>In compliance mode, a protected object version can't be overwritten or deleted by any user, including the root user in your AWS account. When an object is locked in compliance mode, its retention mode can't be changed, and its retention period can't be shortened. Compliance mode helps ensure that an object version can't be overwritten or deleted for the duration of the retention period.
>
>Consider using Governance mode if you want to protect objects from being deleted by most users during a pre-defined retention period, but at the same time want some users with special permissions to have the flexibility to alter the retention settings or delete the objects.

Refer to the [using S3 Object Lock](https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lock.html) and [Object Lock considerations](https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lock-managing.html) documentation for more information.

## IAM Credentials
Generating persistent IAM user access keys is typically not advised ([security best practices in IAM](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)). However, the endpoint backup software this module is designed to integrate with requires an access key ID and secret access key. This module can create an IAM user and IAM policy that only grants read and write access to the backup bucket. Enabling client-side encryption is recommended to enhance data privacy and as an additional layer of security if IAM keys are compromised.

This module provides input variables to configure IAM access key generation. Rotate IAM user keys on a regular basis.

### Out of Band Key Generation
The `create_access_keys` variable is set to `false` by default and requires managing AWS key creation outside of this module. Refer to the [managing access keys for IAM users](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) AWS documentation for more information. AWS will only reveal the secret access key at the time of creation.

Deleting the access keys associated with the user is required before running Terraform destroy or recreating the user resource. Keys are not stored in Terraform state when using this option. Generating IAM access keys outside of Terraform is the most secure option assuming best practices are followed when generating keys.

### Terraform Key Generation
When `create_access_keys` is set to `true`, Terraform will create User access keys. Terraform will store the access key id and secret access key in the state file. Using an encrypted state backend with appropriate access controls is recommended when using this option as the access key id and secret access key can be read from the state file.

The advantage of allowing Terraform to generate the keys is that Terraform can delete or recreate the keys without out of band intervention. Because the permissions of the IAM user are scoped down to only read and write to the backup bucket, the risk profile for storing access keys in the encrypted state file is tolerable. Generating IAM access keys with Terraform and storing the values in state is the most convenient option.

### Terraform Key Generation with PGP Encryption
Terraform can PGP encrypt IAM access keys it creates before storing them in the Terraform state file. Use the `gp_key`, and `gp_key_path` inputs to enable this feature. This is an advanced option and requires additional steps to configure the encryption and decrypt the keys.

Generating IAM access keys with Terraform and encrypting them with PGP is the most complex option but provides an additional layer of security for Terraform generated keys stored in state.

## Terraform Docs
The following documentation is automatically generated by `terraform-docs`. Refer to the module files for configuration details.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=5.43.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=5.43.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_policy.bucket_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_user.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy_attachment.bucket_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_accelerate_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_accelerate_configuration) | resource |
| [aws_s3_bucket_logging.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_object_lock_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_kms_key.aws_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_append_account_id"></a> [bucket\_append\_account\_id](#input\_bucket\_append\_account\_id) | Append the AWS account ID to the S3 bucket name | `bool` | `true` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | S3 bucket name, also used for IAM username and policy name | `string` | `"endpoint-backup"` | no |
| <a name="input_create_access_keys"></a> [create\_access\_keys](#input\_create\_access\_keys) | Create IAM user access keys | `bool` | `false` | no |
| <a name="input_create_iam_user"></a> [create\_iam\_user](#input\_create\_iam\_user) | Create IAM user | `bool` | `true` | no |
| <a name="input_default_lock_days"></a> [default\_lock\_days](#input\_default\_lock\_days) | Default object Lock retention for all new objects when `object_lock_enabled` is set to `true` (`0` disables object locking by default but will still use the lock retention specified by `s3:PutObject` actions) | `number` | `0` | no |
| <a name="input_iam_path"></a> [iam\_path](#input\_iam\_path) | IAM path identifier | `string` | `"/"` | no |
| <a name="input_iam_username"></a> [iam\_username](#input\_iam\_username) | IAM username (bucket name used by default) | `list(string)` | <pre>[<br>  "endpoint-backup"<br>]</pre> | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | Optionally specify a KMS key ARN when using the `aws:kms` server side encryption algorithm (uses the default AWS managed key `aws/s3` when value is `null` | `string` | `null` | no |
| <a name="input_logging"></a> [logging](#input\_logging) | S3 bucket server access logging configuration | <pre>object({<br>    enabled       = bool<br>    target_bucket = string<br>    target_prefix = string<br>  })</pre> | <pre>{<br>  "enabled": false,<br>  "target_bucket": null,<br>  "target_prefix": null<br>}</pre> | no |
| <a name="input_max_compliance_lock_days"></a> [max\_compliance\_lock\_days](#input\_max\_compliance\_lock\_days) | The maximum number of days an S3 object can be locked in compliance mode (does not apply to governance mode) | `number` | `90` | no |
| <a name="input_object_lock_enabled"></a> [object\_lock\_enabled](#input\_object\_lock\_enabled) | Enable S3 object locking (change forces recreation) | `bool` | `false` | no |
| <a name="input_pgp_key"></a> [pgp\_key](#input\_pgp\_key) | Base-64 encoded PGP public key or Keybase username (`keybase:username`) | `string` | `null` | no |
| <a name="input_pgp_key_path"></a> [pgp\_key\_path](#input\_pgp\_key\_path) | Path to a base-64 encoded PGP public key file | `string` | `null` | no |
| <a name="input_sse_algorithm"></a> [sse\_algorithm](#input\_sse\_algorithm) | S3 server side encryption algorithm (`AES256` or `aws:kms`) | `string` | `"AES256"` | no |
| <a name="input_transfer_acceleration"></a> [transfer\_acceleration](#input\_transfer\_acceleration) | S3 transfer acceleration (`Enabled` or `Suspended`) | `string` | `"Suspended"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_key_create_date"></a> [access\_key\_create\_date](#output\_access\_key\_create\_date) | Date and time in RFC3339 format that IAM user access key was created |
| <a name="output_access_key_id"></a> [access\_key\_id](#output\_access\_key\_id) | IAM user access key id |
| <a name="output_encrypted_secret_access_key"></a> [encrypted\_secret\_access\_key](#output\_encrypted\_secret\_access\_key) | IAM user secret access key (Base64 encoded and PGP encrypted) |
| <a name="output_iam_user_arn"></a> [iam\_user\_arn](#output\_iam\_user\_arn) | IAM user ARN |
| <a name="output_iam_user_name"></a> [iam\_user\_name](#output\_iam\_user\_name) | IAM user name |
| <a name="output_pgp_key_fingerprint"></a> [pgp\_key\_fingerprint](#output\_pgp\_key\_fingerprint) | Fingerprint of the PGP key used to encrypt the secret (not available for imported resources) |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | S3 bucket ARN |
| <a name="output_s3_bucket_name"></a> [s3\_bucket\_name](#output\_s3\_bucket\_name) | S3 bucket name |
| <a name="output_secret_access_key"></a> [secret\_access\_key](#output\_secret\_access\_key) | IAM user secret access key |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
