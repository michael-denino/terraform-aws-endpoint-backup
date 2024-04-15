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

output "access_key_id" {
  description = "IAM user access key id"
  sensitive   = true
  value       = module.endpoint_backup_example.access_key_id
}

output "secret_access_key" {
  description = "IAM user secret access key"
  sensitive   = true
  value       = module.endpoint_backup_example.secret_access_key
}

output "access_key_create_date" {
  description = "Date and time in RFC3339 format that IAM user access key was created"
  value       = module.endpoint_backup_example.access_key_create_date
}
