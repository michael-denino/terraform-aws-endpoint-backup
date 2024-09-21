resource "aws_s3_bucket" "this" {
  bucket              = local.bucket_name
  force_destroy       = false
  object_lock_enabled = var.object_lock_enabled
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_logging" "this" {
  count         = var.logging.enabled ? 1 : 0
  bucket        = aws_s3_bucket.this.id
  target_bucket = var.logging.target_bucket
  target_prefix = var.logging.target_prefix
}

resource "aws_s3_bucket_accelerate_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  status = var.transfer_acceleration
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowTLSRequestsOnly",
        "Principal" : "*",
        "Action" : "s3:*",
        "Effect" : "Deny",
        "Resource" : [
          aws_s3_bucket.this.arn,
          "${aws_s3_bucket.this.arn}/*"
        ],
        "Condition" : {
          "Bool" : {
            "aws:SecureTransport" : "false"
          },
          "NumericLessThan" : {
            "s3:TlsVersion" : 1.2
          }
        }
      },
      {
        "Sid" : "ObjectLockBoundry",
        "Principal" : "*",
        "Action" : [
          "s3:PutObject",
          "s3:PutObjectRetention"
        ]
        "Effect" : "Deny",
        "Resource" : "${aws_s3_bucket.this.arn}/*",
        "Condition" : {
          "NumericGreaterThan" : {
            "s3:object-lock-remaining-retention-days" : var.max_compliance_lock_days
          },
          "StringEqualsIgnoreCase" : {
            "s3:object-lock-mode" : "COMPLIANCE"
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = var.sse_algorithm
    }
  }
}

resource "aws_s3_bucket_object_lock_configuration" "this" {
  count  = var.object_lock_enabled && var.default_lock_days > 0 ? 1 : 0
  bucket = aws_s3_bucket.this.id
  rule {
    default_retention {
      mode = "GOVERNANCE"
      days = var.default_lock_days
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    id     = "AbortIncompleteMultipartUploads"
    status = var.abort_incomplete_uploads.status
    abort_incomplete_multipart_upload {
      days_after_initiation = var.abort_incomplete_uploads.days_after_initiation
    }
  }
}
