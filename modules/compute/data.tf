data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "template_file" "user_data_template" {
  template = file("${path.module}/templates/user_data_script.sh.tpl")
  vars = {
    enable_rcon = "${var.enable_rcon}"
    rcon_port   = var.enable_rcon == true ? "${var.rcon_port}" : null
    #is_password_protected      = "${var.is_password_protected}"
    # START palworldsettings.ini inputs
    use_custom_palworldsettings    = "${var.use_custom_palworldsettings}"
    custom_palworldsettings_s3     = var.use_custom_palworldsettings == true ? "${var.custom_palworldsettings_s3}" : false
    palworldsettings_bucket_arn    = var.custom_palworldsettings_s3 == true && length(aws_s3_object.palworldsettings) > 0 ? "s3://${aws_s3_bucket.palworld[0].bucket}/${aws_s3_object.palworldsettings[0].key}" : "na"
    custom_palworldsettings_github = var.use_custom_palworldsettings == true ? "${var.custom_palworldsettings_github}" : false
    github_url                     = var.custom_palworldsettings_github == true ? "${var.custom_palworldsettings_github_url}" : ""
    palworldsettings_ini_path      = var.custom_palworldsettings_s3 == true ? "${var.palworldsettings_ini_path}" : ""
    # END palworldsettings.ini inputs
    # START backup related inputs
    enable_s3_backups               = var.enable_s3_backups
    backup_s3_bucket_name           = "${var.backup_s3_bucket_name}"
    backup_interval_cron_expression = var.enable_s3_backups == true ? var.backup_interval_cron_expression : ""
    # END backup related inputs
    # START start from existing save game data
    start_from_backup                  = "${var.start_from_backup}"
    backup_files_storage_type          = "${var.backup_files_storage_type}"
    backup_files_bootstrap_bucket_arn  = var.start_from_backup == true && var.backup_files_storage_type == "local" ? "${aws_s3_bucket.palworld_bootstrap[0].arn}" : "na"
    backup_files_bootstrap_bucket_name = var.start_from_backup == true && var.backup_files_storage_type == "local" ? "s3://${aws_s3_bucket.palworld_bootstrap[0].bucket}" : "na"
    backup_files_local_path            = var.start_from_backup == true && var.backup_files_storage_type == "local" ? "${var.backup_files_local_path}" : ""
    backup_files_s3_bucket_uri         = var.start_from_backup == true && var.backup_files_storage_type == "s3" ? "${var.backup_files_s3_bucket_uri}" : ""
    # END start from existing save game data
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

    # Can't use a local file and render into the template to be placed into a file because the allowable length of user_data will be exceeded
    #palworldsettings_contents   = var.use_custom_palworldsettings == true ? file("${var.game_user_settings_ini_path}") : null  
  }

  lifecycle {
    precondition {
      condition     = var.enable_rcon == true && var.rcon_port != null || var.enable_rcon == false
      error_message = "rcon_port is defined when enable_rcon = false. rcon_port must be null unless enable_rcon = true."
    }

    precondition {
      condition     = var.enable_rcon == true && var.admin_password != "" || var.enable_rcon == false
      error_message = "admin_password must be set when enable_rcon = true"
    }
  }
}
