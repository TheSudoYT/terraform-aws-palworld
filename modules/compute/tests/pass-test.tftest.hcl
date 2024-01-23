variables {
  // Infrastructure inputs
  ge_proton_version = "8-27"
  instance_type     = "t3.large"
  create_ssh_key    = false
  //ssh_public_key        = "../../ark_public_key.pub"
  // Ark Application inputs
  ark_session_name      = "ark-aws-ascended"
  max_players           = "32"
  enable_rcon           = false
  rcon_port             = null
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
  custom_gameusersettings_github_url = "https://raw.githubusercontent.com/TheSudoYT/ark-aws-ascended-infra/initial/TestGameUserSettings.ini?token=GHSAT0AAAAAACLHVUVTQQZCUG376AYN5MWYZMVX54Q"
  // Custom Game.ini inputs
  use_custom_game_ini       = true
  custom_gameini_s3         = true
  game_ini_path             = "TestGame.ini"
  custom_gameini_github     = false
  custom_gameini_github_url = "https://raw.githubusercontent.com/TheSudoYT/ark-aws-ascended-infra/initial/TestGame.ini?token=GHSAT0AAAAAACLHVUVSGK73KOM27224WCJWZMVYDPA"
  // Backup inputs
  enable_s3_backups               = false
  backup_s3_bucket_name           = ""
  backup_s3_bucket_arn            = ""
  backup_interval_cron_expression = "5 5 5 5 5"
  create_backup_s3_bucket         = false
  s3_bucket_backup_retention      = 7
  force_destroy                   = true
}

provider "aws" {}

// Validate GameUserSettings.ini and Game.ini object when using custom ini with s3
run "pass_validate_custom_ini_files_s3" {

  command = plan

  variables {
    use_custom_gameusersettings        = true
    custom_gameusersettings_s3         = true
    game_user_settings_ini_path        = "../../../TestGameUserSettings.ini"
    custom_gameusersettings_github     = false
    custom_gameusersettings_github_url = ""
    use_custom_game_ini                = true
    custom_gameini_s3                  = true
    game_ini_path                      = "../../../TestGame.ini"
    custom_gameini_github              = false
    custom_gameini_github_url          = ""
  }

  # Check that GameUserSettings.ini object expected to exist in s3
  assert {
    condition     = aws_s3_object.gameusersettings[0].key == "GameUserSettings.ini"
    error_message = "Invalid GameUserSettings.ini in S3 or does not exist in S3 when its expected to."
  }

  # Check that Game.ini object expected to exist in s3
  assert {
    condition     = aws_s3_object.gameini[0].key == "Game.ini"
    error_message = "Invalid Game.ini in S3 or does not exist in S3 when its expected to."
  }
}

// Just make sure an s3 bucket is not created
run "pass_validate_custom_ini_files_github" {

  command = plan

  variables {
    use_custom_gameusersettings        = true
    custom_gameusersettings_s3         = false
    game_user_settings_ini_path        = "../../../TestGameUserSettings.ini"
    custom_gameusersettings_github     = true
    custom_gameusersettings_github_url = "https://raw.githubusercontent.com/TheSudoYT/ark-aws-ascended-infra/initial/TestGameUserSettings.ini?token=GHSAT0AAAAAACLHVUVTFCHETVPC3XAVTGICZMVYWWQ"
    use_custom_game_ini                = true
    custom_gameini_s3                  = false
    game_ini_path                      = "../../../TestGame.ini"
    custom_gameini_github              = true
    custom_gameini_github_url          = "https://raw.githubusercontent.com/TheSudoYT/ark-aws-ascended-infra/initial/TestGame.ini?token=GHSAT0AAAAAACLHVUVTSLPHAJ32H24IUCP4ZMVYWUA"
  }


  # Check that GameUserSettings.ini object expected to exist in s3
  assert {
    condition     = length(aws_s3_bucket.ark) == 0
    error_message = "S3 bucket attempting to be created when an S3 bucket is not expected to be created."
  }
}

// Steam query port passing
run "pass_validate_steam_query_port_valid" {

  command = plan

  variables {
    steam_query_port = 27015
  }


  # Check that GameUserSettings.ini object expected to exist in s3
  assert {
    condition     = var.steam_query_port < 27020 || var.steam_query_port > 27050
    error_message = "Steam uses ports 27020 to 27050. Please choose a different query port."
  }
}

// Validate e2e without custom ini files declared. Ark uses default ini files its instatiated with.
run "pass_validate_no_custom_ini_files_s3" {

  command = plan

  variables {
    use_custom_gameusersettings        = false
    custom_gameusersettings_s3         = false
    game_user_settings_ini_path        = ""
    custom_gameusersettings_github     = false
    custom_gameusersettings_github_url = ""
    use_custom_game_ini                = false
    custom_gameini_s3                  = false
    game_ini_path                      = ""
    custom_gameini_github              = false
    custom_gameini_github_url          = ""
  }

  assert {
    condition     = length(aws_s3_bucket.ark) == 0
    error_message = "An s3 bucket is being created for a .ini file when none is expected."
  }

}

run "pass_validate_rcon_false_password" {

  command = plan

  variables {
    enable_rcon           = false
    rcon_port             = null
    steam_query_port      = 27015
    game_client_port      = 7777
    server_admin_password = "RockwellSucks"
  }

  // Test enable_rcon = false with null rcon_port
  assert {
    condition     = var.enable_rcon == true && var.rcon_port != null || var.enable_rcon == false && var.rcon_port == null
    error_message = "rcon_port is defined when enable_rcon = false. rcon_port must be null unless enable_rcon = true."
  }

  // Test enable_rcon = false with server_admin_password set
  assert {
    condition     = var.enable_rcon == true && var.server_admin_password != "" || var.enable_rcon == false
    error_message = "server_admin_password must be set when enable_rcon = true"
  }
}

run "pass_validate_rcon_true_password" {

  command = plan

  variables {
    enable_rcon           = true
    rcon_port             = 27011
    steam_query_port      = 27015
    game_client_port      = 7777
    server_admin_password = "RockwellSucks"
  }

  // Test enable_rcon = true with defined rcon_port
  assert {
    condition     = var.enable_rcon == true && var.rcon_port != null || var.enable_rcon == false && var.rcon_port == null
    error_message = "rcon_port is defined when enable_rcon = false. rcon_port must be null unless enable_rcon = true."
  }

  // Test enable_rcon = true with server_admin_password set
  assert {
    condition     = var.enable_rcon == true && var.server_admin_password != "" || var.enable_rcon == false
    error_message = "server_admin_password must be set when enable_rcon = true"
  }
}

run "pass_validate_proton_version" {

  command = plan

  module {
    source = "./tests/setup"
  }

  variables {
    ge_proton_version = "8-27"
  }


  assert {
    condition     = data.http.ge_proton.status_code == 200
    error_message = "${data.http.ge_proton.url} returned an unhealthy status code for version ${var.ge_proton_version}"
  }
}

run "pass_validate_server_platforms" {

  command = plan

  variables {
    supported_server_platforms = ["PC", "PS5", "XSX", "WINGDK", "ALL"]
  }

  assert {
    condition     = alltrue([for v in var.supported_server_platforms : contains(["PC", "PS5", "XSX", "WINGDK", "ALL"], v)])
    error_message = "Each supported server platform must be one of 'PC', 'PS5', 'XSX', 'WINGDK', or 'ALL'."
  }
}
