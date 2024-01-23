variables {
  // Infrastructure inputs
  instance_type  = "t3.large"
  create_ssh_key = false
  //ssh_public_key        = "../../ark_public_key.pub"
  // Ark Application inputs
  ark_session_name      = "ark-aws-ascended"
  max_players           = "32"
  steam_query_port      = 27015
  game_client_port      = 7777
  server_admin_password = "RockwellSucks"
  is_password_protected = true
  join_password         = "RockWellSucks"
  // Custom GameUserSettings.ini inputs
  use_custom_gameusersettings        = true
  custom_gameusersettings_s3         = true
  game_user_settings_ini_path        = "TestGameUserSettings.ini"
  custom_gameusersettings_github     = true
  custom_gameusersettings_github_url = "https://raw.githubusercontent.com/TheSudoYT/ark-aws-ascended-infra/initial/TestGameUserSettings.ini?token=GHSAT0AAAAAACLHVUVTQQZCUG376AYN5MWYZMVX54Q"
  // Custom Game.ini inputs
  use_custom_game_ini       = true
  custom_gameini_s3         = true
  game_ini_path             = "TestGame.ini"
  custom_gameini_github     = true
  custom_gameini_github_url = "https://raw.githubusercontent.com/TheSudoYT/ark-aws-ascended-infra/initial/TestGame.ini?token=GHSAT0AAAAAACLHVUVSGK73KOM27224WCJWZMVYDPA"
  // Backup inputs
  enable_s3_backups               = false
  backup_s3_bucket_name           = ""
  backup_s3_bucket_arn            = ""
  backup_interval_cron_expression = "*/5 * * * *"
  create_backup_s3_bucket         = false
  s3_bucket_backup_retention      = 7
  force_destroy                   = true
}

provider "aws" {}


// // Validate terraform does not create an s3 bucket to upload a custom ini file to if custom_gameusersettings_s3 or custom_game_ini_s3 are false
// run "ini_conflict" {

//   command = plan

// variables{
//   use_custom_gameusersettings        = true
//   custom_gameusersettings_s3         = true
//   game_user_settings_ini_path        = "TestGameUserSettings.ini"
//   custom_gameusersettings_github     = true
//   custom_gameusersettings_github_url = "https://raw.githubusercontent.com/TheSudoYT/ark-aws-ascended-infra/initial/TestGameUserSettings.ini?token=GHSAT0AAAAAACLHVUVTQQZCUG376AYN5MWYZMVX54Q"
//   // Custom Game.ini inputs
//   use_custom_game_ini       = true
//   custom_gameini_s3         = true
//   game_ini_path             = "TestGame.ini"
//   custom_gameini_github     = true
//   custom_gameini_github_url = "https://raw.githubusercontent.com/TheSudoYT/ark-aws-ascended-infra/initial/TestGame.ini?token=GHSAT0AAAAAACLHVUVSGK73KOM27224WCJWZMVYDPA"
//   // Backup inputs
// }
//   # Check that GameUserSettings.ini exists in S3
//   assert {
//     condition     = module.ark_compute.custom_ini_s3_bucket_name[0] == null
//     error_message = "Tried to create an S3 bucket for custom .ini files when none were requested."
//   }

// }
