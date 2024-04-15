data "aws_caller_identity" "current" {}

locals {
  name = "example-sse-kms-endpoint-backup"
}

resource "aws_kms_key" "s3" {
  description             = local.name
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_kms_alias" "s3" {
  name          = "alias/${local.name}"
  target_key_id = aws_kms_key.s3.key_id
}

resource "aws_kms_key_policy" "s3" {
  key_id = aws_kms_key.s3.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AdministratorRolePermissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : data.aws_caller_identity.current.arn
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
      {
        "Sid" : "IAMUserPermissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : module.endpoint_backup_example.iam_user_arn
        },
        "Action" : [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ],
        "Resource" : "*"
      }
    ]
  })
}

module "endpoint_backup_example" {
  source             = "../../"
  bucket_name        = local.name
  create_access_keys = true
  sse_algorithm      = "aws:kms"
  kms_key_arn        = aws_kms_key.s3.arn
  iam_username       = [local.name]
}
