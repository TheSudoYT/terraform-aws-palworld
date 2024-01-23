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
  custom_gameusersettings_github     = false
  custom_gameusersettings_github_url = ""
  // Custom Game.ini inputs
  use_custom_game_ini       = true
  custom_gameini_s3         = true
  game_ini_path             = "TestGame.ini"
  custom_gameini_github     = false
  custom_gameini_github_url = ""
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


// Validate GameUserSettings.ini and Game.ini are uploaded to S3 when desired
run "validate_custom_ini_files_in_s3" {

  command = apply

  # Check that GameUserSettings.ini exists in S3
  assert {
    condition     = module.ark_compute.custom_gameusersettings_file_name[0] == "GameUserSettings.ini"
    error_message = "Invalid GameUserSettings.ini in S3 or does not exist in S3 when its expected to."
  }

  # Check that Game.ini exists in S3
  assert {
    condition     = module.ark_compute.custom_game_file_name[0] == "Game.ini"
    error_message = "Invalid Game.ini in S3 or does not exist in S3 when its expected to."
  }

  // assert {
  //   condition     = data.http.example.status_code[0] == 200
  //   error_message = "test"
  // }

}

// Validate GameUserSettings.ini and Game.ini are downloaded from GitHub when desired
run "validate_custom_ini_files_in_github" {

  command = plan

  # Check that GameUserSettings.ini exists in S3
  assert {
    condition     = module.ark_compute.custom_gameusersettings_file_name[0] == "GameUserSettings.ini"
    error_message = "Invalid GameUserSettings.ini in S3 or does not exist in S3 when its expected to."
  }

  # Check that Game.ini exists in S3
  assert {
    condition     = module.ark_compute.custom_game_file_name[0] == "Game.ini"
    error_message = "Invalid Game.ini in S3 or does not exist in S3 when its expected to."
  }
}


// Querry Battlemetrics API
