module "palworld_vpc" {
  source = "./modules/networking"

  vpc_cidr_block           = var.vpc_cidr_block
  subnet_cidr_block        = var.subnet_cidr_block
  subnet_availability_zone = var.subnet_availability_zone
  enable_rcon              = var.enable_rcon
  rcon_port                = var.rcon_port
  public_port              = var.public_port
}

module "palworld_compute" {
  source = "./modules/compute"

  instance_type              = var.instance_type
  palworld_security_group_id = module.palworld_vpc.security_group_id
  palworld_subnet_id         = module.palworld_vpc.subnet_id
  create_ssh_key             = var.create_ssh_key
  ssh_public_key             = var.create_ssh_key == true ? var.ssh_public_key : ""
  existing_ssh_key_name      = var.existing_ssh_key_name
  ssh_key_name               = var.ssh_key_name
  ssh_ingress_allowed_cidr   = var.ssh_ingress_allowed_cidr
  ami_id                     = var.ami_id
  ebs_volume_size            = var.ebs_volume_size
  enable_rcon                = var.enable_rcon
  rcon_port                  = var.rcon_port
  # Custom PalworldSettings.ini inputs
  use_custom_palworldsettings        = var.use_custom_palworldsettings
  custom_palworldsettings_s3         = var.custom_palworldsettings_s3
  palworldsettings_ini_path          = var.palworldsettings_ini_path
  custom_palworldsettings_github     = var.custom_palworldsettings_github
  custom_palworldsettings_github_url = var.custom_palworldsettings_github_url
  # Backup inputs
  enable_s3_backups                         = var.enable_s3_backups
  backup_s3_bucket_name                     = var.enable_s3_backups == true && var.create_backup_s3_bucket == true ? module.palworld_backup.backup_s3_bucket_name[0] : var.backup_s3_bucket_name
  backup_s3_bucket_arn                      = var.enable_s3_backups == true && var.create_backup_s3_bucket == true ? module.palworld_backup.backup_s3_bucket_arn[0] : var.backup_s3_bucket_arn
  backup_interval_cron_expression           = var.backup_interval_cron_expression
  start_from_backup                         = var.start_from_backup
  backup_files_storage_type                 = var.backup_files_storage_type
  backup_files_local_path                   = var.backup_files_local_path
  backup_files_s3_bucket_uri                = var.backup_files_s3_bucket_uri
  difficulty                                = var.difficulty
  day_time_speed_rate                       = var.day_time_speed_rate
  night_time_speed_rate                     = var.night_time_speed_rate
  exp_rate                                  = var.exp_rate
  pal_capture_rate                          = var.pal_capture_rate
  pal_spawn_num_rate                        = var.pal_spawn_num_rate
  pal_damage_rate_attack                    = var.pal_damage_rate_attack
  pal_damage_rate_defense                   = var.pal_damage_rate_defense
  player_damage_rate_attack                 = var.player_damage_rate_attack
  player_damage_rate_defense                = var.player_damage_rate_defense
  player_stomach_decrease_rate              = var.player_stomach_decrease_rate
  player_stamina_decrease_rate              = var.player_stamina_decrease_rate
  player_auto_hp_regen_rate                 = var.player_auto_hp_regen_rate
  player_auto_hp_regen_rate_in_sleep        = var.player_auto_hp_regen_rate_in_sleep
  pal_stomach_decrease_rate                 = var.pal_stomach_decrease_rate
  pal_stamina_decrease_rate                 = var.pal_stamina_decrease_rate
  pal_auto_hp_regen_rate                    = var.pal_auto_hp_regen_rate
  pal_auto_hp_regene_rate_in_sleep          = var.pal_auto_hp_regene_rate_in_sleep
  build_object_damage_rate                  = var.build_object_damage_rate
  build_object_deterioration_damage_rate    = var.build_object_deterioration_damage_rate
  collection_drop_rate                      = var.collection_drop_rate
  collection_object_hp_rate                 = var.collection_object_hp_rate
  collection_object_respawn_speed_rate      = var.collection_object_respawn_speed_rate
  enemy_drop_item_rate                      = var.enemy_drop_item_rate
  death_penalty                             = var.death_penalty
  enable_player_to_player_damage            = var.enable_player_to_player_damage
  enable_friendly_fire                      = var.enable_friendly_fire
  enable_invader_enemy                      = var.enable_invader_enemy
  active_unko                               = var.active_unko
  enable_aim_assist_pad                     = var.enable_aim_assist_pad
  enable_aim_assist_keyboard                = var.enable_aim_assist_keyboard
  drop_item_max_num                         = var.drop_item_max_num
  drop_item_max_num_unko                    = var.drop_item_max_num_unko
  base_camp_max_num                         = var.base_camp_max_num
  base_camp_worker_max_num                  = var.base_camp_worker_max_num
  drop_item_alive_max_hours                 = var.drop_item_alive_max_hours
  auto_reset_guild_no_online_players        = var.auto_reset_guild_no_online_players
  auto_reset_guild_time_no_online_players   = var.auto_reset_guild_time_no_online_players
  guild_player_max_num                      = var.guild_player_max_num
  pal_egg_default_hatching_time             = var.pal_egg_default_hatching_time
  work_speed_rate                           = var.work_speed_rate
  is_multiplay                              = var.is_multiplay
  is_pvp                                    = var.is_pvp
  can_pickup_other_guild_death_penalty_drop = var.can_pickup_other_guild_death_penalty_drop
  enable_non_login_penalty                  = var.enable_non_login_penalty
  enable_fast_travel                        = var.enable_fast_travel
  is_start_location_select_by_map           = var.is_start_location_select_by_map
  exist_player_after_logout                 = var.exist_player_after_logout
  enable_defense_other_guild_player         = var.enable_defense_other_guild_player
  coop_player_max_num                       = var.coop_player_max_num
  server_player_max_num                     = var.server_player_max_num
  server_name                               = var.server_name
  server_description                        = var.server_description
  admin_password                            = var.admin_password
  server_password                           = var.server_password
  public_port                               = var.public_port
  public_ip                                 = var.public_ip
  region                                    = var.region
  use_auth                                  = var.use_auth
  ban_list_url                              = var.ban_list_url
}

module "palworld_backup" {
  source = "./modules/backup"

  create_backup_s3_bucket    = var.create_backup_s3_bucket
  s3_bucket_backup_retention = var.s3_bucket_backup_retention
  force_destroy              = var.force_destroy
}

# Notes
# terraform turns floats into integers. When specifying a number input of 1.0 terraform converts it to 1.
