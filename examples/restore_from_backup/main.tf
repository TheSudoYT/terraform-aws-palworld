module "palworld" {
  source = "../.."

  # Infrastructure inputs
  instance_type                               = "t3.xlarge"
  create_ssh_key                              = true
  ssh_public_key                              = "../../palworld_public_key.pub"
  start_from_backup                           = true
  backup_files_storage_type                   = "s3"
  backup_files_local_path                     = "../../assets"
  dedicated_server_name_hash                  = "FA8C44A6FA46436AAAE4D414C4214B25"
  existing_backup_files_bootstrap_bucket_arn  = "arn:aws:s3:::palworld-mysaves22"
  existing_backup_files_bootstrap_bucket_name = "palworld-mysaves22"
}
