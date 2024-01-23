module "asa" {
  source = "../.."

  # Infrastructure inputs
  ge_proton_version = "8-27"
  instance_type     = "t3.xlarge"
  create_ssh_key    = true
  ssh_public_key    = "../../ark_public_key.pub"
  # Ark Application inputs
  use_battleye          = false
  auto_save_interval    = 20.0
  ark_session_name      = "ark-aws-ascended"
  max_players           = "32"
  enable_rcon           = true
  rcon_port             = 27011
  steam_query_port      = 27015
  game_client_port      = 7777
  server_admin_password = "RockwellSucks"
  is_password_protected = true
  join_password         = "RockWellSucks"
  # Custom GameUserSettings.ini inputs
  use_custom_gameusersettings        = true
  custom_gameusersettings_s3         = true
  game_user_settings_ini_path        = "../../TestGameUserSettings.ini"
  custom_gameusersettings_github     = false
  custom_gameusersettings_github_url = ""
  # Custom Game.ini inputs
  use_custom_game_ini       = true
  custom_gameini_s3         = true
  game_ini_path             = "../../TestGame.ini"
  custom_gameini_github     = false
  custom_gameini_github_url = ""
  # Backup inputs
  enable_s3_backups               = true
  backup_s3_bucket_name           = ""
  backup_s3_bucket_arn            = ""
  backup_interval_cron_expression = "*/5 * * * *"
  create_backup_s3_bucket         = true
  s3_bucket_backup_retention      = 7
  force_destroy                   = true
  # Restore settings
  start_from_backup         = true
  backup_files_storage_type = "local"
  backup_files_local_path   = "../../assets"
}
