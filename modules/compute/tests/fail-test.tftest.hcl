

provider "aws" {}

variables {
  instance_type  = "t3.large"
  create_ssh_key = false
  ssh_public_key = ""
}

// Validate precondition is outputting error when user attempts to use a custom palworldsettings.ini from both s3 and github
run "fail_validate_custom_ini_precondition_palworldsettings" {

  command = plan

  variables {
    use_custom_palworldsettings        = true
    custom_palworldsettings_s3         = true
    palworldsettings_ini_path          = ""
    custom_palworldsettings_github     = true
    custom_palworldsettings_github_url = ""
  }

  expect_failures = [
    aws_instance.palworld_server
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


run "fail_validate_rcon_true_port_undefined" {

  command = plan

  variables {
    enable_rcon    = true
    rcon_port      = null
    public_port    = 8211
    admin_password = "RockwellSucks"
  }

  // Expect failure for rcon port = null when enable_rcon = true
  expect_failures = [
    data.template_file.user_data_template
  ]

}

run "fail_validate_rcon_true_password_undefined" {

  command = plan

  variables {
    enable_rcon    = true
    rcon_port      = 27011
    public_port    = 8211
    admin_password = ""
  }

  // Expect failure for admin_password = "" when enable_rcon = true
  expect_failures = [
    data.template_file.user_data_template
  ]

}
