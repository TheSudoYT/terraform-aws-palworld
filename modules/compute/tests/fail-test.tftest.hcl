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
  backup_interval_cron_expression = "*/5 * * * *"
  create_backup_s3_bucket         = false
  s3_bucket_backup_retention      = 7
  force_destroy                   = true
}

provider "aws" {}

// Validate precondition is outputting error when user attempts to use a custom gameusersettings.ini from both s3 and github
run "fail_validate_custom_ini_precondition_gameusersettings" {

  command = plan

  variables {
    use_custom_gameusersettings        = true
    custom_gameusersettings_s3         = true
    game_user_settings_ini_path        = ""
    custom_gameusersettings_github     = true
    custom_gameusersettings_github_url = ""
    use_custom_game_ini                = false
    custom_gameini_s3                  = false
    game_ini_path                      = ""
    custom_gameini_github              = false
    custom_gameini_github_url          = ""
  }

  expect_failures = [
    aws_instance.ark_server
  ]
}

// Validate precondition is outputting error when user attempts to use a custom game.ini from both s3 and github
run "fail_validate_custom_ini_precondition_gameini" {

  command = plan

  variables {
    use_custom_gameusersettings        = false
    custom_gameusersettings_s3         = false
    game_user_settings_ini_path        = ""
    custom_gameusersettings_github     = false
    custom_gameusersettings_github_url = ""
    use_custom_game_ini                = true
    custom_gameini_s3                  = true
    game_ini_path                      = ""
    custom_gameini_github              = true
    custom_gameini_github_url          = ""
  }

  expect_failures = [
    aws_instance.ark_server
  ]

}

// Validate precondition is outputting error when user attempts to use a custom game.ini and gameusesettings.ini from both s3 and github
run "fail_validate_custom_ini_precondition_gameini_gameusersettingsini" {

  command = plan

  variables {
    use_custom_gameusersettings        = true
    custom_gameusersettings_s3         = true
    game_user_settings_ini_path        = ""
    custom_gameusersettings_github     = true
    custom_gameusersettings_github_url = ""
    use_custom_game_ini                = true
    custom_gameini_s3                  = true
    game_ini_path                      = ""
    custom_gameini_github              = true
    custom_gameini_github_url          = ""
  }

  expect_failures = [
    aws_instance.ark_server
  ]
}

// Steam query port not valid
run "fail_validate_steam_query_port_invalid" {

  command = plan

  variables {
    steam_query_port = 27025
  }

  expect_failures = [
    var.steam_query_port
  ]
}

// // Cron expression is not valid - Broken
// run "fail_validate_cron_expression_invalid" {

//   command = plan

//   variables {
//     backup_interval_cron_expression = "*/5 * * * *"
//   }

//   expect_failures = [
//     var.backup_interval_cron_expression
//   ]
// }

run "fail_validate_rcon_false_port_defined" {

  command = plan

  variables {
    enable_rcon           = false
    rcon_port             = 27011
    steam_query_port      = 27015
    game_client_port      = 7777
    server_admin_password = "RockwellSucks"
  }

  // Expect failure for rcon port defined when enable_rcon = false
  expect_failures = [
    data.template_file.user_data_template
  ]

}

run "fail_validate_rcon_true_port_undefined" {

  command = plan

  variables {
    enable_rcon           = true
    rcon_port             = null
    steam_query_port      = 27015
    game_client_port      = 7777
    server_admin_password = "RockwellSucks"
  }

  // Expect failure for rcon port = null when enable_rcon = true
  expect_failures = [
    data.template_file.user_data_template
  ]

}

run "fail_validate_rcon_true_password_undefined" {

  command = plan

  variables {
    enable_rcon           = true
    rcon_port             = 27011
    steam_query_port      = 27015
    game_client_port      = 7777
    server_admin_password = ""
  }

  // Expect failure for server_admin_password = "" when enable_rcon = true
  expect_failures = [
    data.template_file.user_data_template
  ]

}


run "fail_validate_proton_version" {

  command = plan

  module {
    source = "./tests/setup"
  }

  variables {
    ge_proton_version = "99-99"
  }


  expect_failures = [
    check.ge_proton_version_check
  ]

}

run "fail_validate_server_platforms" {

  command = plan

  variables {
    supported_server_platforms = ["PC", "PS5", "XSX", "WINGDK", "ALL", "POOP"]
  }

  expect_failures = [
    var.supported_server_platforms
  ]
}
