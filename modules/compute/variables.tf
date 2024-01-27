variable "create_ssh_key" {
  description = "True or False. Determines if an SSH key is created in AWS"
  type        = bool
  default     = true
}

variable "existing_ssh_key_name" {
  description = "The name of an EXISTING SSH key for use with the EC2 instance"
  type        = string
  default     = null
}

variable "ssh_key_name" {
  description = "The name of the SSH key to be created for use with the EC2 instance"
  type        = string
  default     = "palworld-ssh-key"
}

variable "ssh_public_key" {
  description = "The path to the ssh public key to be used with the EC2 instance"
  type        = string
  default     = "~/.ssh/palworld_public_key.pub"
}

variable "ssh_ingress_allowed_cidr" {
  description = "The CIDR range to allow SSH incoming connections from"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

### ec2 variables ###
variable "ami_id" {
  description = "The AMI ID to use. Not providing one will result in the latest version of Ubuntu Focal 20.04 being used"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "The instance type to use"
  type        = string
  default     = "t3.large"
}

variable "palworld_security_group_id" {
  description = "The ID of the security group to use with the EC2 instance"
  type        = string
  default     = ""
}

variable "palworld_subnet_id" {
  description = "The ID of the security group to use with the EC2 instance"
  type        = string
  default     = ""
}

variable "ebs_volume_size" {
  description = "The size of the EBS volume attached to the EC2 instance"
  type        = number
  default     = 40
}

variable "use_custom_palworldsettings" {
  description = "True or False. Set true if you want to provide your own PalWorldSettings.ini file when the server is started. Required if game_user_settings_ini_path is defined"
  type        = bool
  default     = false
}

variable "custom_palworldsettings_s3" {
  description = "True or False. Set true if use_custom_palworldsettings is true and you want to upload and download them from an S3 bucket during installation"
  type        = bool
  default     = false
}

variable "custom_palworldsettings_github" {
  description = "True or False. Set true if use_custom_palworldsettings is true and you want to download them from github. Must be a public repo."
  type        = bool
  default     = false
}

variable "custom_palworldsettings_github_url" {
  description = "The URL to the PalWorldSettings.ini file on a public GitHub repo. Used when custom_palworldsettings_github and custom_game_usersettings both == true."
  type        = string
  default     = ""
}

variable "palworldsettings_ini_path" {
  description = "Path to PalWorldSettings.ini relative to your Terraform working directory. Will be uploaded to the server. Required if use_custom_palworldsettings = true and custom_game_usersettings_s3 = true."
  type        = string
  default     = ""
}

variable "enable_s3_backups" {
  description = "True or False. Set to true to enable backing up of the ShooterGame/Saved directory to S3"
  type        = bool
  default     = false
}

variable "backup_s3_bucket_arn" {
  description = "The ARN of the s3 bucket that you would like to use for ShooterGame/Saved directory backups"
  type        = string
  default     = ""
}

variable "backup_s3_bucket_name" {
  description = "The name of the S3 bucket to backup the ShooterGame/Saved directory to"
  type        = string
  default     = ""
}

variable "backup_interval_cron_expression" {
  description = "How often to backup the ShooterGame/Saved directory to S3 in cron expression format (https://crontab.cronhub.io/)"
  type        = string
  default     = "0 23 * * *"
}

# Backup inputs
variable "create_backup_s3_bucket" {
  description = "True or False. Do you want to create an S3 bucket to FTP backups into"
  type        = bool
  default     = false
}

variable "s3_bucket_backup_retention" {
  description = "Lifecycle rule. The number of days to keep backups in S3 before they are deleted"
  type        = number
  default     = 7
}

variable "force_destroy" {
  description = "True or False. Set to true if you want Terraform destroy commands to have the ability to destroy the backup bucket while it still containts backup files"
  type        = bool
  default     = false
}

## Restore from backups
variable "start_from_backup" {
  description = "True of False. Set true to start the server from an existing palworld save. Requires existing save game files."
  type        = bool
  default     = false
}

variable "backup_files_storage_type" {
  description = "The location of your save game files that you wish to start the server with. Supported options are `local` or `s3'. `local` means the save game files exist somewhere on the host you are running terraform apply from. `s3` means the files exist in an s3 bucket."
  type        = string
  default     = "local"

  validation {
    condition     = var.backup_files_storage_type == "local" || var.backup_files_storage_type == "s3"
    error_message = "Invalid storage type. The only valid inputs are 'local' or 's3'."
  }

}

# if backup_files_storage_type local && start_from_backup = true. Local needs to upload files to an s3 bucket and download.
variable "backup_files_local_path" {
  description = "Path to existing save game files relative to your Terraform working directory. Will be uploaded to the server. Required if `backup_files_storage_path = local` "
  type        = string
  default     = ""
}

variable "dedicated_server_name_hash" {
  description = "The DedicatedServerName= value from the old servers GameUserSettings.ini. Will be set on the new server to ensure data properly loads with backup data."
  type        = string
  default     = ""
}

# if backup_files_storage_type s3 && start_from_backup = true
variable "existing_backup_files_bootstrap_bucket_arn" {
  description = "The ARN of an existing S3 bucket with Palworld save game data. Files will be downloaded to the server. Objects must be in the root of the S3 bucket and not compressed."
  type        = string
  default     = ""
}

variable "existing_backup_files_bootstrap_bucket_name" {
  description = "The Name of an existing S3 bucket with Palworld save game data. Files will be downloaded to the server. Objects must be in the root of the S3 bucket and not compressed."
  type        = string
  default     = ""
}

###############################################
### Application PalWorldSettings.ini Inputs ###
###############################################
variable "difficulty" {
  description = "Game difficulty setting"
  type        = string
  default     = "None"
}

variable "day_time_speed_rate" {
  description = "Day time speed rate"
  type        = number
  default     = 1.0
}

variable "night_time_speed_rate" {
  description = "Night time speed rate"
  type        = number
  default     = 1.0
}

variable "exp_rate" {
  description = "Experience rate"
  type        = number
  default     = 1.0
}

variable "pal_capture_rate" {
  description = "Pal capture rate"
  type        = number
  default     = 1.0
}

variable "pal_spawn_num_rate" {
  description = "Pal spawn number rate"
  type        = number
  default     = 1.0
}

variable "pal_damage_rate_attack" {
  description = "Pal damage rate on attack"
  type        = number
  default     = 1.0
}

variable "pal_damage_rate_defense" {
  description = "Pal damage rate on defense"
  type        = number
  default     = 1.0
}

variable "player_damage_rate_attack" {
  description = "Player damage rate on attack"
  type        = number
  default     = 1.0
}

variable "player_damage_rate_defense" {
  description = "Player damage rate on defense"
  type        = number
  default     = 1.0
}

variable "player_stomach_decrease_rate" {
  description = "Player stomach decrease rate"
  type        = number
  default     = 1.0
}

variable "player_stamina_decrease_rate" {
  description = "Player stamina decrease rate"
  type        = number
  default     = 1.0
}

variable "player_auto_hp_regen_rate" {
  description = "Player auto HP regeneration rate"
  type        = number
  default     = 1.0
}

variable "player_auto_hp_regen_rate_in_sleep" {
  description = "Player auto HP regeneration rate in sleep"
  type        = number
  default     = 1.0
}

variable "pal_stomach_decrease_rate" {
  description = "Pal stomach decrease rate"
  type        = number
  default     = 1.0
}

variable "pal_stamina_decrease_rate" {
  description = "Pal stamina decrease rate"
  type        = number
  default     = 1.0
}

variable "pal_auto_hp_regen_rate" {
  description = "Pal auto HP regeneration rate"
  type        = number
  default     = 1.0
}

variable "pal_auto_hp_regene_rate_in_sleep" {
  description = "Pal auto HP regeneration rate in sleep"
  type        = number
  default     = 1.0
}

variable "build_object_damage_rate" {
  description = "Build object damage rate"
  type        = number
  default     = 1.0
}

variable "build_object_deterioration_damage_rate" {
  description = "Build object deterioration damage rate"
  type        = number
  default     = 1.0
}

variable "collection_drop_rate" {
  description = "Collection drop rate"
  type        = number
  default     = 1.0
}

variable "collection_object_hp_rate" {
  description = "Collection object HP rate"
  type        = number
  default     = 1.0
}

variable "collection_object_respawn_speed_rate" {
  description = "Collection object respawn speed rate"
  type        = number
  default     = 1.0
}

variable "enemy_drop_item_rate" {
  description = "Enemy drop item rate"
  type        = number
  default     = 1.0
}

variable "death_penalty" {
  description = "Death penalty setting. None : No lost, Item : Lost item without equipment, ItemAndEquipment : Lost item and equipment, All : Lost All item, equipment, pal(in inventory)"
  type        = string
  default     = "Item"

  validation {
    condition     = var.death_penalty == "None" || var.death_penalty == "Item" || var.death_penalty == "ItemAndEquipment" || var.death_penalty == "All"
    error_message = "Invalid value for death_penalty. Allowed values are None, Item, ItemAndEquipment, or All.\n"
  }
}

variable "enable_player_to_player_damage" {
  description = "Enable player to player damage"
  type        = bool
  default     = false
}

variable "enable_friendly_fire" {
  description = "Enable friendly fire"
  type        = bool
  default     = false
}

variable "enable_invader_enemy" {
  description = "Enable invader enemy"
  type        = bool
  default     = true
}

variable "active_unko" {
  description = "Activate UNKO setting"
  type        = bool
  default     = false
}

variable "enable_aim_assist_pad" {
  description = "Enable aim assist for pad"
  type        = bool
  default     = true
}

variable "enable_aim_assist_keyboard" {
  description = "Enable aim assist for keyboard"
  type        = bool
  default     = false
}

variable "drop_item_max_num" {
  description = "Maximum number of drop items"
  type        = number
  default     = 3000
}

variable "drop_item_max_num_unko" {
  description = "Maximum number of UNKO drop items"
  type        = number
  default     = 100
}

variable "base_camp_max_num" {
  description = "Maximum number of base camps"
  type        = number
  default     = 128
}

variable "base_camp_worker_max_num" {
  description = "Maximum number of base camp workers"
  type        = number
  default     = 15
}

variable "drop_item_alive_max_hours" {
  description = "Maximum hours a drop item is alive"
  type        = number
  default     = 1.0
}

variable "auto_reset_guild_no_online_players" {
  description = "Auto reset guild when no online players"
  type        = bool
  default     = false
}

variable "auto_reset_guild_time_no_online_players" {
  description = "Time for auto reset guild when no online players"
  type        = number
  default     = 72.0
}

variable "guild_player_max_num" {
  description = "Maximum number of players in a guild"
  type        = number
  default     = 20
}

variable "pal_egg_default_hatching_time" {
  description = "Default hatching time for pal eggs"
  type        = number
  default     = 72.0
}

variable "work_speed_rate" {
  description = "Work speed rate"
  type        = number
  default     = 1.0
}

variable "is_multiplay" {
  description = "Is the game in multiplay mode"
  type        = bool
  default     = false
}

variable "is_pvp" {
  description = "Is the game in PvP mode"
  type        = bool
  default     = false
}

variable "can_pickup_other_guild_death_penalty_drop" {
  description = "Can players pick up other guild's death penalty drop"
  type        = bool
  default     = false
}

variable "enable_non_login_penalty" {
  description = "Enable penalty for non-login"
  type        = bool
  default     = true
}

variable "enable_fast_travel" {
  description = "Enable fast travel"
  type        = bool
  default     = true
}

variable "is_start_location_select_by_map" {
  description = "Is start location selected by map"
  type        = bool
  default     = false
}

variable "exist_player_after_logout" {
  description = "Does player exist in game after logout"
  type        = bool
  default     = false
}

variable "enable_defense_other_guild_player" {
  description = "Enable defense against other guild players"
  type        = bool
  default     = false
}

variable "coop_player_max_num" {
  description = "Maximum number of players in coop mode"
  type        = number
  default     = 32
}

variable "server_player_max_num" {
  description = "Maximum number of players on server"
  type        = number
  default     = 32
}

variable "server_name" {
  description = "Server name"
  type        = string
  default     = "AWSWorldTest"
}

variable "server_description" {
  description = "Server description"
  type        = string
  default     = "Running On AWS"
}

variable "admin_password" {
  description = "Admin password"
  type        = string
  default     = "RockwellSucks"
}

variable "server_password" {
  description = "Server password"
  type        = string
  default     = "RockwellSucks"
}

variable "public_port" {
  description = "Public port number"
  type        = number
  default     = 8211
}

variable "public_ip" {
  description = "Public IP address"
  type        = string
  default     = ""
}

variable "enable_rcon" {
  description = "Is RCON enabled"
  type        = bool
  default     = false
}

variable "rcon_port" {
  description = "RCON port number"
  type        = number
  default     = 27025
}

variable "region" {
  description = "Server region"
  type        = string
  default     = ""
}

variable "use_auth" {
  description = "Use authentication"
  type        = bool
  default     = true
}

variable "ban_list_url" {
  description = "URL of the ban list"
  type        = string
  default     = "https://api.palworldgame.com/api/banlist.txt"
}