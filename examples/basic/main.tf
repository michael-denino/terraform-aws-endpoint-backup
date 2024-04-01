module "endpoint_backup_example" {
  source              = "../../"
  bucket_name         = "example-basic-endpoint-backup"
  create_access_keys  = true
  object_lock_enabled = true
  iam_username        = ["example-basic-endpoint-backup"]
}
