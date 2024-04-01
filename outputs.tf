output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.this.arn
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.this.bucket
}

output "iam_user_arn" {
  description = "IAM user ARN"
  value       = var.create_iam_user ? values(aws_iam_user.this)[*].arn : null
}

output "iam_user_name" {
  description = "IAM user name"
  value       = var.create_iam_user ? values(aws_iam_user.this)[*].name : null
}

output "access_key_create_date" {
  description = "Date and time in RFC3339 format that IAM user access key was created"
  value       = var.create_access_keys ? values(aws_iam_access_key.this)[*].create_date : null
}

output "access_key_id" {
  description = "IAM user access key id"
  sensitive   = true
  value       = var.create_access_keys ? values(aws_iam_access_key.this)[*].id : null
}

output "secret_access_key" {
  description = "IAM user secret access key"
  sensitive   = true
  value       = var.create_access_keys && local.pgp_key == null ? values(aws_iam_access_key.this)[*].secret : null
}

output "encrypted_secret_access_key" {
  description = "IAM user secret access key (Base64 encoded and PGP encrypted)"
  sensitive   = true
  value       = var.create_access_keys && local.pgp_key != null ? values(aws_iam_access_key.this)[*].encrypted_secret : null
}

output "pgp_key_fingerprint" {
  description = "Fingerprint of the PGP key used to encrypt the secret (not available for imported resources)"
  sensitive   = true
  value       = var.create_access_keys && local.pgp_key != null ? values(aws_iam_access_key.this)[*].key_fingerprint : null
}
