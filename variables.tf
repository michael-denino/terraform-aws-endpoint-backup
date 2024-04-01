variable "bucket_name" {
  description = "S3 bucket name, also used for IAM username and policy name"
  type        = string
  default     = "endpoint-backup"
}

variable "bucket_append_account_id" {
  description = "Append the AWS account ID to the S3 bucket name"
  type        = bool
  default     = true
}

variable "iam_username" {
  description = "IAM username (bucket name used by default)"
  type        = list(string)
  default     = ["endpoint-backup"]
}

variable "iam_path" {
  description = "IAM path identifier"
  type        = string
  default     = "/"
}

variable "transfer_acceleration" {
  description = "S3 transfer acceleration (`Enabled` or `Suspended`)"
  type        = string
  default     = "Suspended"
}

variable "logging" {
  description = "S3 bucket server access logging configuration"
  type = object({
    enabled       = bool
    target_bucket = string
    target_prefix = string
  })
  default = {
    enabled       = false
    target_bucket = null
    target_prefix = null
  }
}

variable "sse_algorithm" {
  description = "S3 server side encryption algorithm (`AES256` or `aws:kms`)"
  type        = string
  default     = "AES256"
}

variable "kms_key_arn" {
  description = "Optionally specify a KMS key ARN when using the `aws:kms` sse algorithm"
  type        = string
  default     = null
}

variable "create_access_keys" {
  description = "Create IAM user access keys"
  type        = bool
  default     = false
}

variable "create_iam_user" {
  description = "Create IAM user"
  type        = bool
  default     = true
}

variable "pgp_key" {
  description = "Base-64 encoded PGP public key or Keybase username (`keybase:username`)"
  type        = string
  default     = null
}

variable "pgp_key_path" {
  description = "Path to a base-64 encoded PGP public key file"
  type        = string
  default     = null
}

variable "object_lock_enabled" {
  description = "Enable S3 object locking (change forces recreation)"
  type        = bool
  default     = false
}

variable "default_lock_days" {
  description = "Default object Lock retention for all new objects when `object_lock_enabled` is set to `true` (`0` disables object locking by default but will still use the lock retention specified by `s3:PutObject` actions)"
  type        = number
  default     = 0
}

variable "max_compliance_lock_days" {
  description = "The maximum number of days an S3 object can be locked in compliance mode (does not apply to governance mode)"
  type        = number
  default     = 90
  validation {
    condition     = var.max_compliance_lock_days <= 1095
    error_message = <<EOF
    This module does not permit setting the S3 object compliance lock boundry to greater than 1095 days. This boundary is based on the use case of the module and the consequences on locking S3 objects in compliance mode. This restriction does not apply to objects locks using governance mode.

    In compliance mode, a protected object version can't be overwritten or deleted by any user, including the root user in your AWS account. When an object is locked in compliance mode, its retention mode can't be changed, and its retention period can't be shortened. Compliance mode helps ensure that an object version can't be overwritten or deleted for the duration of the retention period.

    Consider using Governance mode if you want to protect objects from being deleted by most users during a pre-defined retention period, but at the same time want some users with special permissions to have the flexibility to alter the retention settings or delete the objects.

    https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lock.html
    https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lock-managing.html
    EOF
  }
}
