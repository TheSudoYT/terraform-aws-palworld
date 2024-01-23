variables {
  create_backup_s3_bucket    = false
  s3_bucket_backup_retention = 7
  force_destroy              = true
}

provider "aws" {}

// Just make sure an s3 bucket is not created when create bucket is false
run "pass-validate-no-s3-bucket" {

  command = plan

  variables {
    create_backup_s3_bucket    = false
    s3_bucket_backup_retention = 7
    force_destroy              = true
  }

  assert {
    condition     = length(aws_s3_bucket.ark_backup_bucket) == 0
    error_message = "Backup S3 bucket attempting to be created when an S3 bucket is not expected to be created."
  }
}
