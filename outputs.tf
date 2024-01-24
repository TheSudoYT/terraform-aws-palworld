output "backup_s3_bucket_name" {
  value       = module.palworld_backup.backup_s3_bucket_name
  description = "The Name of the S3 bucket created to store backups if enabled"
}

output "custom_ini_s3_bucket_name" {
  value       = module.palworld_compute.custom_ini_s3_bucket_name
  description = "The ID of the S3 bucket that was created if use custom ini with s3 was configured."
}

output "palworldsettings_s3_content" {
  value       = module.palworld_compute.palworldsettings_s3_content
  description = "The contents of the palworldsettings.ini ( experimental )."
}

output "palworld_server_public_port" {
  value       = module.palworld_compute.palworld_server_public_port
  description = "The public port to connect to the Palworld serer on"
}

output "palworld_server_public_ip" {
  value       = module.palworld_compute.palworld_server_public_ip
  description = "The public IP address of the Palworld server to connect on."
}