locals {
  endpoint_backup_name = "example-logging-endpoint-backup"
}

module "endpoint_backup_example" {
  source              = "../../"
  bucket_name         = local.endpoint_backup_name
  create_access_keys  = true
  object_lock_enabled = true
  iam_username        = [local.endpoint_backup_name]
  logging = {
    enabled       = true
    target_bucket = aws_s3_bucket.logs.bucket
    target_prefix = "${local.endpoint_backup_name}/"
  }
}

# S3 bucket to act as centralized log storage for all buckets
resource "aws_s3_bucket" "logs" {
  bucket        = join("-", ["example-logging-target", data.aws_caller_identity.current.account_id])
  force_destroy = true # for development only, remove in production
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.logs.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "S3-Console-Auto-Gen-Policy-1711923949085",
    "Statement" : [
      {
        "Sid" : "AllowLogPuts",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "logging.s3.amazonaws.com"
        },
        "Action" : "s3:PutObject",
        "Resource" : "${aws_s3_bucket.logs.arn}/*",
        "Condition" : {
          "ArnLike" : {
            "aws:SourceArn" : module.endpoint_backup_example.s3_bucket_arn
          },
          "StringEquals" : {
            "aws:SourceAccount" : data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}
