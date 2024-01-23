output "backup_s3_bucket_name" {
  value       = aws_s3_bucket.palworld_backup_bucket[*].id
  description = "The ID of the S3 bucket created for backups if enabled."
}

output "backup_s3_bucket_arn" {
  value       = aws_s3_bucket.palworld_backup_bucket[*].arn
  description = "The ARN of the S3 bucket created for backups if enabled."
}
