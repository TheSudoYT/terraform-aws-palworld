provider "aws" {}

run "pass_validate_rcon_false_port_null" {
  command = plan

  variables {
    enable_rcon      = false
    rcon_port        = null
    steam_query_port = 27015
    game_client_port = 7777
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
    enable_rcon      = true
    rcon_port        = 27011
    steam_query_port = 27015
    game_client_port = 7777
  }

  // Test enable_rcon = true with defined rcon_port
  assert {
    condition     = var.enable_rcon == true && var.rcon_port != null || var.enable_rcon == false && var.rcon_port == null
    error_message = "rcon_port is defined when enable_rcon = false. rcon_port must be null unless enable_rcon = true."
  }
}
