module "asa" {
  source = "TheSudoYT/ark-survival-ascended/aws"

  # Infrastructure inputs
  ge_proton_version = "8-27"
  instance_type     = "t3.xlarge"
  create_ssh_key    = true
  ssh_public_key    = "../../ark_public_key.pub"
  # Ark Application inputs
  use_battleye                       = false
  auto_save_interval                 = 20.0
  ark_session_name                   = "ark-aws-ascended"
  max_players                        = "32"
  enable_rcon                        = true
  rcon_port                          = 27011
  steam_query_port                   = 27015
  game_client_port                   = 7777
  server_admin_password              = "RockwellSucks"
  is_password_protected              = true
  join_password                      = "RockWellSucks"
  use_custom_gameusersettings        = true
  custom_gameusersettings_github     = true
  custom_gameusersettings_github_url = "https://raw.githubusercontent.com/TheSudoYT/ark-aws-ascended-infra/initial/TestGameUserSettings.ini?token=GHSAT0AAAAAACLHVUVTFCHETVPC3XAVTGICZMVYWWQ"
  use_custom_game_ini                = true
  custom_gameini_github              = true
  custom_gameini_github_url          = "https://raw.githubusercontent.com/TheSudoYT/ark-aws-ascended-infra/initial/TestGame.ini?token=GHSAT0AAAAAACLHVUVTSLPHAJ32H24IUCP4ZMVYWUA"
}
