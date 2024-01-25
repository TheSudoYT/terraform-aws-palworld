provider "aws" {}


run "pass_validate_rcon_false_port_null" {
  command = plan

  variables {
    enable_rcon = false
    rcon_port   = null
    public_port = 8211
  }

  // Test enable_rcon = false with null rcon_port
  assert {
    condition     = var.enable_rcon == true && var.rcon_port != null || var.enable_rcon == false && var.rcon_port == null
    error_message = "rcon_port is defined when enable_rcon = false. rcon_port must be null unless enable_rcon = true."
  }
}

run "pass_validate_rcon_true_port_defined" {

  command = plan

  variables {
    enable_rcon = true
    rcon_port   = 27025
    public_port = 8211
  }

  // Test enable_rcon = true with defined rcon_port
  assert {
    condition     = var.enable_rcon == true && var.rcon_port != null || var.enable_rcon == false && var.rcon_port == null
    error_message = "rcon_port is defined when enable_rcon = false. rcon_port must be null unless enable_rcon = true."
  }
}
