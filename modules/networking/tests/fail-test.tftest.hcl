provider "aws" {}

// run "fail_validate_rcon_false_port_defined" {

//   command = plan

//   variables {
//     enable_rcon      = false
//     rcon_port        = 27025
//     public_port      = 8211
//   }

//   // Expect failure for rcon port defined when enable_rcon = false
//   expect_failures = [
//     aws_security_group.palworld_security_group
//   ]

// }

run "fail_validate_rcon_true_port_undefined" {

  command = plan

  variables {
    enable_rcon = true
    rcon_port   = null
    public_port = 8211
  }

  // Expect failure for rcon port = null when enable_rcon = true
  expect_failures = [
    aws_security_group.palworld_security_group
  ]

}
