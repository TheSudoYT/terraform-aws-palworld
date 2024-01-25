variables {
  instance_type                             = "t3.xlarge"
  create_ssh_key                            = false
  ssh_public_key                            = ""
  difficulty                                = "Normal"
  day_time_speed_rate                       = 1.0
  night_time_speed_rate                     = 1.0
  exp_rate                                  = 1.0
  pal_capture_rate                          = 1.0
  pal_spawn_num_rate                        = 1.0
  pal_damage_rate_attack                    = 1.0
  pal_damage_rate_defense                   = 1.0
  player_damage_rate_attack                 = 1.0
  player_damage_rate_defense                = 1.0
  player_stomach_decrease_rate              = 1.0
  player_stamina_decrease_rate              = 1.0
  player_auto_hp_regen_rate                 = 1.0
  player_auto_hp_regen_rate_in_sleep        = 1.0
  pal_stomach_decrease_rate                 = 1.0
  pal_stamina_decrease_rate                 = 1.0
  pal_auto_hp_regen_rate                    = 1.0
  pal_auto_hp_regene_rate_in_sleep          = 1.0
  build_object_damage_rate                  = 1.0
  build_object_deterioration_damage_rate    = 1.0
  collection_drop_rate                      = 1.0
  collection_object_hp_rate                 = 1.0
  collection_object_respawn_speed_rate      = 1.0
  enemy_drop_item_rate                      = 1.0
  death_penalty                             = "Item"
  enable_player_to_player_damage            = false
  enable_friendly_fire                      = false
  enable_invader_enemy                      = true
  active_unko                               = false
  enable_aim_assist_pad                     = true
  enable_aim_assist_keyboard                = false
  drop_item_max_num                         = 3000
  drop_item_max_num_unko                    = 100
  base_camp_max_num                         = 128
  base_camp_worker_max_num                  = 15
  drop_item_alive_max_hours                 = 1.0
  auto_reset_guild_no_online_players        = false
  auto_reset_guild_time_no_online_players   = 72.0
  guild_player_max_num                      = 20
  pal_egg_default_hatching_time             = 72.0
  work_speed_rate                           = 1.0
  is_multiplay                              = false
  is_pvp                                    = false
  can_pickup_other_guild_death_penalty_drop = false
  enable_non_login_penalty                  = true
  enable_fast_travel                        = true
  is_start_location_select_by_map           = false
  exist_player_after_logout                 = false
  enable_defense_other_guild_player         = false
  coop_player_max_num                       = 32
  server_player_max_num                     = 32
  server_name                               = "FarOverTheMistyMountains"
  server_description                        = "Running On AWS Managed with Terraform"
  admin_password                            = "RockwellSucks"
  server_password                           = "RockwellSucks"
  public_port                               = 8211
  public_ip                                 = ""
  region                                    = ""
  use_auth                                  = true
  enable_rcon                               = false
  rcon_port                                 = 27025
  ban_list_url                              = "https://api.palworldgame.com/api/banlist.txt"
  use_custom_palworldsettings               = true
  custom_palworldsettings_s3                = true
  palworldsettings_ini_path                 = "TestPalWorldSettings.ini"
  custom_palworldsettings_github            = false
  custom_palworldsettings_github_url        = ""
  enable_s3_backups                         = true
  backup_s3_bucket_name                     = ""
  backup_s3_bucket_arn                      = ""
  backup_interval_cron_expression           = "*/5 * * * *"
  create_backup_s3_bucket                   = true
  s3_bucket_backup_retention                = 7
  force_destroy                             = true
  start_from_backup                         = true
  backup_files_storage_type                 = "local"
  backup_files_local_path                   = "../../assets"
}

provider "aws" {}


// Validate PalWorldSettings.ini are uploaded to S3 when desired
run "validate_custom_ini_files_in_s3" {

  command = apply

  # Check that PalWorldSettings.ini exists in S3
  assert {
    condition     = module.palworld_compute.custom_palworldsettings_file_name[0] == "PalWorldSettings.ini"
    error_message = "Invalid PalWorldSettings.ini in S3 or does not exist in S3 when its expected to."
  }

}
