provider "aws" {}

run "fail_validate_rcon_false_port_defined" {

  command = plan

  variables {
    enable_rcon      = false
    rcon_port        = 27011
    steam_query_port = 27015
    game_client_port = 7777
  }

  // Expect failure for rcon port defined when enable_rcon = false
  expect_failures = [
    aws_security_group.ark_security_group
  ]

}

run "fail_validate_rcon_true_port_undefined" {

  command = plan

  variables {
    enable_rcon      = true
    rcon_port        = null
    steam_query_port = 27015
    game_client_port = 7777
  }

  // Expect failure for rcon port = null when enable_rcon = true
  expect_failures = [
    aws_security_group.ark_security_group
  ]

}
