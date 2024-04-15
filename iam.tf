resource "aws_iam_user" "this" {
  for_each = var.create_iam_user ? toset(var.iam_username) : []
  name     = each.value
  path     = var.iam_path
}

resource "aws_iam_policy" "bucket_access" {
  name        = "${var.bucket_name}-bucket-read-write-access"
  path        = var.iam_path
  description = "Single bucket access"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowListBucket",
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:ListBucketMultipartUploads",
          "s3:ListBucketVersions",
          "s3:GetBucketObjectLockConfiguration",
          "s3:PutBucketObjectLockConfiguration"
        ],
        "Resource" : aws_s3_bucket.this.arn
      },
      {
        "Sid" : "AllowBucketActions",
        "Effect" : "Allow",
        "Action" : [
          "s3:AbortMultipartUpload",
          "s3:ListMultipartUploadParts",
          "s3:DeleteObject",
          "s3:DeleteObjectVersion",
          "s3:GetObject",
          "s3:GetObjectAcl",
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:PutObjectVersionAcl",
          "s3:PutObjectRetention",
          "s3:RestoreObject"
        ],
        "Resource" : "${aws_s3_bucket.this.arn}/*"
      },
      {
        "Sid" : "AllowListAllMyBuckets",
        "Effect" : "Allow",
        "Action" : "s3:ListAllMyBuckets",
        "Resource" : aws_s3_bucket.this.arn
      },
      {
        "Sid" : "AllowKMSActions",
        "Effect" : "Allow",
        "Action" : [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ],
        "Resource" : var.kms_key_arn != null ? var.kms_key_arn : data.aws_kms_key.aws_s3.arn
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "bucket_access" {
  for_each   = var.create_iam_user ? toset(var.iam_username) : []
  user       = aws_iam_user.this[each.value].name
  policy_arn = aws_iam_policy.bucket_access.arn
}

resource "aws_iam_access_key" "this" {
  for_each = var.create_access_keys ? toset(var.iam_username) : []
  user     = aws_iam_user.this[each.value].name
  pgp_key  = local.pgp_key
}
