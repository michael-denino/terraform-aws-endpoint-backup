data "aws_caller_identity" "current" {}

data "aws_kms_key" "aws_s3" {
  key_id = "alias/aws/s3"
}
