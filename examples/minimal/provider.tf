provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      terraform = "true"
      purpose   = "endpoint_backup_example_minimal"
    }
  }
}
