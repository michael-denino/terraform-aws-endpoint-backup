locals {
  pgp_key     = var.pgp_key_path == null ? var.pgp_key : file(var.pgp_key_path)
  bucket_name = var.bucket_append_account_id == true ? join("-", [var.bucket_name, data.aws_caller_identity.current.account_id]) : var.bucket_name
}
