output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = module.endpoint_backup_example.s3_bucket_arn
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = module.endpoint_backup_example.s3_bucket_name
}

output "iam_user_arn" {
  description = "IAM user ARN"
  value       = module.endpoint_backup_example.iam_user_arn
}

output "iam_user_name" {
  description = "IAM user name"
  value       = module.endpoint_backup_example.iam_user_name
}
