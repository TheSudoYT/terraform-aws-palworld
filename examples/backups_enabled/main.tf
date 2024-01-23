module "palworld" {
  source = "../.."

  instance_type                   = "t3.large"
  create_ssh_key                  = true
  ssh_public_key                  = "../../palworld_public_key.pub"
  use_custom_palworldsettings     = true
  custom_palworldsettings_s3      = true
  palworldsettings_ini_path       = "../../TestPalWorldSettings.ini"
  enable_s3_backups               = true
  create_backup_s3_bucket         = true
  backup_interval_cron_expression = "*/5 * * * *"
  s3_bucket_backup_retention      = 7
  force_destroy                   = true
  backup_s3_bucket_arn            = ""
  backup_s3_bucket_name           = ""
  day_time_speed_rate             = "6.0"
}
