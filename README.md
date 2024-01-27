# Palworld Dedicated Server Terraform Module
Palworld Server Infrastructure Terraform module.

- Palworld dedicated server docs 
https://tech.palworldgame.com/optimize-game-balance

## Donate
I do this in my free time. Consider donating to keep the project going and motivate me to maintain the repo, add new features, etc :) 

![Support on Patreon](https://img.shields.io/badge/Patreon-F96854?style=for-the-badge&logo=patreon&logoColor=white) 

[Support on Patreon](https://patreon.com/ThSudo?utm_medium=clipboard_copy&utm_source=copyLink&utm_campaign=creatorshare_creator&utm_content=join_link)

![Support on By Me A Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)

[Support on BuyMeACoffee](https://www.buymeacoffee.com/TheSudo)

![Subscribe](https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white)

[Subscribe on YouTube](https://www.youtube.com/c/TheSudo)

# About
This module allows you to quickly deploy an Palworld server on AWS.

### Key Features
- Palworldrunning on Ubuntu
- The ability to use an existing PalWorldSettings.ini
- PalWorldSettings.ini settings are configurable inputs for creating a brand new configuration
- Ability to store backups in S3 at a defined interval
- Ability to start from existing save data

# How to Use
## Prerequisites
You must have the following to use this Terraform module:
- Terraform version >= 1.5.0 - [Install Terraform](https://developer.hashicorp.com/terraform/install)
- An AWS account

## Usage
1. Create a file named `main.tf`
2. Add the following as a minimum. See all available inputs in the "Inputs" section of this README. Inputs not defined will use their default values.
```hcl
module "palworld" {
  source  = "TheSudoYT/palworld/aws"

  instance_type                 = "t3.xlarge"
  create_ssh_key                = true
  ssh_public_key                = "../../palworld_public_key.pub"
  server_name                   = "palworld-on-aws"
  server_player_max_num         = 32
}
```
3. Choose your inputs - `PalWorldSettings.ini` inputs use default values unless you provide a value OTHER than the default value. Palworld will use the settings from a custom PalWorldSettings.ini file if you choose to use one. Modifying an input that is a PalWorldSettings.ini setting while also using a custom PalWorldSettings.ini file will result ONLY the values in your custom .ini file being used.

> [!WARNING]
> Any of the inputs that are also settings in the PalWorldSettings.ini file will be ignored if `use_custom_palworldsettings = true`. For example, if you say `exp_rate = 3.0` and also say  `use_custom_palworldsettings = true` then the value in your custom PalWorldSettings.ini will be used and the value of exp_rate will be ignored.

4. Initialize Terraform - Run `terraform init` to download the module and providers.
5. Create the Palworld server and Infrastructure - Run `terraform apply` to start deploying the infrastructure.

## Accessing the Server

> [!WARNING]
> As of Jan 23, 2024 users are reporting a bug preventing servers from appearing in the community servers list or search filter. If this happens you can still connect to the server using the EC2 instance IP address and the `public_port` you have set (default 8211)

> [!NOTE]
> In testing it takes approximately 10 minutes on a t3.xlarge for steam to download and configure Palworld.

The terraform apply will complete, but the server will not appear in the server list until this completes. You can SSH into your server `ssh -i my_palworld_key.pem ubuntu@1.2.3.4` and use `journalctl -xu cloud-final` to monitor the install. See the troubleshooting section of the README if you continue to have problems.

> [!NOTE]
> In testing it takes approximately 3 to 5 minutes for your server to appear on the community server list after installation is complete.

## Backups
This module includes the option to enable backups. Enabling this will backup the `Pal/Saved/SaveGame` directory to an S3 bucket at the interval specified using cron. Backups will be retained in S3 based on the number of days specified by the input `s3_bucket_backup_retention`. This is to save money. Versioning, kms, and replication are disabled to save money.

> [!NOTE] 
> Enabling this creates an additional S3 bucket. In testing, this adds an additional 0.10 USD ( 10 cents ) a month on average depending on the duration of backup retention, how often you backup, and how often you restore from backup. https://calculator.aws/#/addService

2 Files will be created on the Palworld server; `palworld_backup_script.sh` on install and `palworld_backup_log.log` when the first backup job runs. 

The backup should be visible in the AWS S3 bucket after the first specified backup interval time frame passes.

## Using an Existing PalWorldSettings.ini
You can use an existing PalWorldSettings.ini so that the server starts with your custom settings. The following inputs are required to do this:

> [!WARNING]
> Any of the inputs that are also settings in the PalWorldSettings.ini file will be ignored if `use_custom_palworldsettings = true`. For example, if you say `exp_rate = 3.0` and also say  `use_custom_palworldsettings = true` then the value in your custom PalWorldSettings.ini will be used and the value of exp_rate will be ignored.

| Input | Description |
| ------------- | ------------- |
| use_custom_palworldsettings = true | Must be set to pass a custom PalWorldSettings.ini to the server on startup |
| custom_palworldsettings_s3 = true | Cannot be set when `custom_palworldsettings_github = true`. Set to true if you would like to upload an existing PalWorldSettings.ini to an S3 bucket during terraform apply. Setting this to true will create an S3 bucket and upload the file from your PC to the S3 bucket. It will then download the file from the S3 bucket on server startup. You MUST also set `palworldsettings_ini_path` as a path on your local system relative to the terraform working directory. It is easiest to just place PalWorldSettings.ini in the root of your terraform working directory and just provide `palworldsettings_ini_path = PalWorldSettings.ini`. |
| palworldsettings_ini_path = "path/on/my/pc" | A path on your local system relative to the terraform working directory. It is easiest to just place PalWorldSettings.ini in the root of your terraform working directory and just provide `game_user_settings_ini_path = PalWorldSettings.ini`. Only used when `custom_palworldsettings_s3 = true`. |
| custom_palworldsettings_github = true | Cannot be set when `custom_palworldsettings_s3 = true`. Set to true if you would like to download an existing PalWorldSettings.ini to the server from a GitHub URL. Must also provide `custom_palworldsettings_github_url = "https://my.url.com` with a valid URL to a public GitHub repo. |
| custom_palworldsettings_github_url = "https://my.url.com | A valid URL to a public GitHub repo to download an existing PalWorldSettings.ini from onto the server during startup. Must have `custom_palworldsettings_github = true` and `use_custom_palworldsettings = true` to use.|

- Using the S3 option will instruct terraform to create an S3 bucket along with an EC2 instance profile that will have permissions to assume an IAM role that is also created. This role contains a policy to allow only the EC2 instance to access the S3 bucket to download PalWorldSettings.ini. This also instructs the user_data script that runs when the server starts to download PalWorldSettings.ini from that S3 bucket and place it in `/palworld-server/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini`

- Using the GitHub option will simply instruct the user_data script that runs when the server starts to download PalWorldSettings.ini to the server and place it in `/palworld-server/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini`

## Starting From Existing Save Data, Restoring From Backups, or Migrating Servers
>[!DANGER]
> You MUST know the DedicatedServerName value set in your old palworld servers `Pal/Saved/Config/LinuxServer/GameUserSettings.ini` file. This is also the name of the directory from the old server that contained your .sav files.

>[!NOTE]
> Using this modules `enable_s3_backups = true` option will backup the `GameUserSettings.ini` file to S3 as well in the event the server is lost.

### Using You Own S3 Bucket ( Bring Your Own )

Set `backup_files_storage_type = "s3"` if you have an AWS s3 bucket somewhere with the backups files already in it. Please note the warning below about the REQUIRED file structure of the bucket. Terraform and user_data are opinionated in how they retrieve and place these files, so you must adhere to this structure.

> [!WARNING]
> When `backup_files_storage_type = "s3"` using The objects in the S3 bucket must not be compressed and must be in the root of the S3 bucket. The bucket's file structure MUST match the picture below. It will be synced to the `SaveGame/0/<dedicated_server_name>` directory.

![Required S3 Structure](docs/images/restore_from_existing_s3_structure.png)

### Using Local Files

Set `backup_files_storage_type = "local"` if the save files are on your local host PC. Please note the warning below about the REQUIRED file structure of the bucket. Terraform and user_data are opinionated in how they retrieve and place these files, so you must adhere to this structure.

> [!WARNING]
> When `backup_files_storage_type = "local"` using The objects/files in the directory you specify with `backup_files_local_path` must not be compressed. Terraform will iterate through each file in that directory and upload it to the root of an S3 bucket it creates. It will do this for `backup_files_local_path/Players` as well.

Required local file structure

![Required Local File Structure](docs/images/restore_from_local_files.png)

- `backup_files_storage_type = "local"` will instruct terraform to create an S3 bucket named `palworld-bootstrap-local-saves-<region>-<accID>` and upload the save files from your local PC `backup_files_local_path` directory specified to that bucket. The user_data script on the EC2 instance will download the files from that S3 bucket when the server starts and place them in the `/palworld-server/Pal/Saved/SaveGames/0/<dedicated_server_name_hash>` directory.

- `backup_files_storage_type = "s3"` Is informing terraform that you have an existing S3 bucket somewhere that contains the save game data. The EC2 user_data script will attempt to sync the root of that S3 bucket with the `SaveGames/0/<dedicated_server_name_hash>` directory. It will also attempt to sync the S3 buckets `Players` folder to `SaveGames/0/<dedicated_server_name_hash>/Players` That is why it is important that the objects be uncompressed and in the proper structure. 

> [!WARNING]
> When `backup_files_storage_type = "local"` using The objects/files in the directory you specify with `backup_files_local_path` must not be compressed. Terraform will iterate through each file in that directory and upload it to the root of an S3 bucket it creates.

### Usage - Restore From Local Files
Relevant inputs:

```HCL
  start_from_backup         = true
  backup_files_storage_type = "local"
  dedicated_server_name_hash = "FA8C44A6FA46436AAAE4D414C4214B25"
  backup_files_local_path   = "../../assets"
```

### Usage - Restore From an Existing S3 Bucket ( Bring Your Own S3 Bucket)
Relevant inputs:

```HCL
  start_from_backup         = true
  backup_files_storage_type = "s3"
  dedicated_server_name_hash = "FA8C44A6FA46436AAAE4D414C4214B25"
  existing_backup_files_bootstrap_bucket_arn  = "arn:aws:s3:::palworld-existing-s3-bucket-bootstrap"
  existing_backup_files_bootstrap_bucket_name = "palworld-existing-s3-bucket-bootstrap"
```

- If start from backup = true then dedicated_server_name_hash is required

## Troubleshooting
- Monitoring the installation - You can view the user_data script that ran by connecting to your server via SSH using the public key you provided, ubuntu user, and the IP address of the server. Example: `ssh -i .\palworld_public_key ubuntu@34.225.216.87`. Once on the server you can view the progress of the user_data script that installs and configures palworld using the command `journalctl -xu cloud-final`. Use the space bar to scroll through the output line by line or `shift+g` to scroll the end of the output. If there is an obvvious reason that palworld failed to install or start in the way you expect, you can most likely find it here.

- Checking the palworld service is running - You can run `systemctl status palworld` to view the status of the palworld server. The service should say `Active: active (running)`. If it does not, then the palworld server failed to start or has stopped for some reason.

## Examples
- [Using a Custom PalWorldSetting.ini From S3](https://github.com/TheSudoYT/terraform-aws-palworld/tree/main/examples/custom_palworldsettings_s3)
- [Using a Custom PalWorldSettings.ini From GitHub](https://github.com/TheSudoYT/terraform-aws-palworld/tree/main/examples/custom_palworldsettings_github)
- [Enabling backups to S3](https://github.com/TheSudoYT/terraform-aws-palworld/tree/main/examples/backups_enabled)
- [Using Default Palworld Settings](https://github.com/TheSudoYT/terraform-aws-palworld/tree/main/examples/vanilla_palworld_default_settings)
- [Restoring From Backup Files](https://github.com/TheSudoYT/terraform-aws-palworld/tree/main/examples/restore_from_backup)

## Possible and Known Bugs
Memory leak?
https://www.reddit.com/r/Palworld/comments/19bdsrn/dedicated_server_ram_usage/

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_palworld_backup"></a> [palworld\_backup](#module\_palworld\_backup) | ./modules/backup | n/a |
| <a name="module_palworld_compute"></a> [palworld\_compute](#module\_palworld\_compute) | ./modules/compute | n/a |
| <a name="module_palworld_vpc"></a> [palworld\_vpc](#module\_palworld\_vpc) | ./modules/networking | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_active_unko"></a> [active\_unko](#input\_active\_unko) | Activate UNKO setting | `bool` | `false` | no |
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | Admin password | `string` | `"RockwellSucks"` | no |
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | The AMI ID to use. Not providing one will result in the latest version of Ubuntu Focal 20.04 being used | `string` | `null` | no |
| <a name="input_auto_reset_guild_no_online_players"></a> [auto\_reset\_guild\_no\_online\_players](#input\_auto\_reset\_guild\_no\_online\_players) | Auto reset guild when no online players | `bool` | `false` | no |
| <a name="input_auto_reset_guild_time_no_online_players"></a> [auto\_reset\_guild\_time\_no\_online\_players](#input\_auto\_reset\_guild\_time\_no\_online\_players) | Time for auto reset guild when no online players | `number` | `72` | no |
| <a name="input_backup_files_local_path"></a> [backup\_files\_local\_path](#input\_backup\_files\_local\_path) | Path to existing save game files relative to your Terraform working directory. Will be uploaded to the server. Required if `backup_files_storage_path = local` | `string` | `""` | no |
| <a name="input_backup_files_storage_type"></a> [backup\_files\_storage\_type](#input\_backup\_files\_storage\_type) | The location of your save game files that you wish to start the server with. Supported options are `local` or `s3'. `local` means the save game files exist somewhere on the host you are running terraform apply from. `s3` means the files exist in an s3 bucket.` | `string` | `"local"` | no |        
| <a name="input_backup_interval_cron_expression"></a> [backup\_interval\_cron\_expression](#input\_backup\_interval\_cron\_expression) | How often to backup the ShooterGame/Saved directory to S3 in cron expression format (https://crontab.cronhub.io/) | `string` | `"0 23 * * *"` | no |
| <a name="input_backup_s3_bucket_arn"></a> [backup\_s3\_bucket\_arn](#input\_backup\_s3\_bucket\_arn) | The ARN of the s3 bucket that you would like to use for ShooterGame/Saved directory backups | `string` | `""` | no |
| <a name="input_backup_s3_bucket_name"></a> [backup\_s3\_bucket\_name](#input\_backup\_s3\_bucket\_name) | The name of the S3 bucket to backup the ShooterGame/Saved directory to | `string` | `""` | no |
| <a name="input_ban_list_url"></a> [ban\_list\_url](#input\_ban\_list\_url) | URL of the ban list | `string` | `"https://api.palworldgame.com/api/banlist.txt"` | no |
| <a name="input_base_camp_max_num"></a> [base\_camp\_max\_num](#input\_base\_camp\_max\_num) | Maximum number of base camps | `number` | `128` | no |
| <a name="input_base_camp_worker_max_num"></a> [base\_camp\_worker\_max\_num](#input\_base\_camp\_worker\_max\_num) | Maximum number of base camp workers | `number` | `15` | no |
| <a name="input_build_object_damage_rate"></a> [build\_object\_damage\_rate](#input\_build\_object\_damage\_rate) | Build object damage rate | `number` | `1` | no |
| <a name="input_build_object_deterioration_damage_rate"></a> [build\_object\_deterioration\_damage\_rate](#input\_build\_object\_deterioration\_damage\_rate) | Build object deterioration damage rate | `number` | `1` | no |
| <a name="input_can_pickup_other_guild_death_penalty_drop"></a> [can\_pickup\_other\_guild\_death\_penalty\_drop](#input\_can\_pickup\_other\_guild\_death\_penalty\_drop) | Can players pick up other guild's death penalty drop | `bool` | `false` | no |
| <a name="input_collection_drop_rate"></a> [collection\_drop\_rate](#input\_collection\_drop\_rate) | Collection drop rate | `number` | `1` | no |
| <a name="input_collection_object_hp_rate"></a> [collection\_object\_hp\_rate](#input\_collection\_object\_hp\_rate) | Collection object HP rate | `number` | `1` | no |
| <a name="input_collection_object_respawn_speed_rate"></a> [collection\_object\_respawn\_speed\_rate](#input\_collection\_object\_respawn\_speed\_rate) | Collection object respawn speed rate | `number` | `1` | no |
| <a name="input_coop_player_max_num"></a> [coop\_player\_max\_num](#input\_coop\_player\_max\_num) | Maximum number of players in coop mode | `number` | `32` | no |
| <a name="input_create_backup_s3_bucket"></a> [create\_backup\_s3\_bucket](#input\_create\_backup\_s3\_bucket) | True or False. Do you want to create an S3 bucket to FTP backups into | `bool` | `false` | no |
| <a name="input_create_ssh_key"></a> [create\_ssh\_key](#input\_create\_ssh\_key) | True or False. Determines if an SSH key is created in AWS | `bool` | `true` | no |
| <a name="input_custom_palworldsettings_github"></a> [custom\_palworldsettings\_github](#input\_custom\_palworldsettings\_github) | True or False. Set true if use\_custom\_palworldsettings is true and you want to download them from github. Must be a public repo. | `bool` | `false` | no |
| <a name="input_custom_palworldsettings_github_url"></a> [custom\_palworldsettings\_github\_url](#input\_custom\_palworldsettings\_github\_url) | The URL to the PalWorldSettings.ini file on a public GitHub repo. Used when custom\_palworldsettings\_github and custom\_game\_usersettings both == true. | `string` | `""` | no |
| <a name="input_custom_palworldsettings_s3"></a> [custom\_palworldsettings\_s3](#input\_custom\_palworldsettings\_s3) | True or False. Set true if use\_custom\_palworldsettings is true and you want to upload and download them from an S3 bucket during installation | `bool` | `false` | no |
| <a name="input_day_time_speed_rate"></a> [day\_time\_speed\_rate](#input\_day\_time\_speed\_rate) | Day time speed rate | `number` | `1` | no |
| <a name="input_death_penalty"></a> [death\_penalty](#input\_death\_penalty) | Death penalty setting. None : No lost, Item : Lost item without equipment, ItemAndEquipment : Lost item and equipment, All : Lost All item, equipment, pal(in inventory) | `string` | `"Item"` | no |
| <a name="input_dedicated_server_name_hash"></a> [dedicated\_server\_name\_hash](#input\_dedicated\_server\_name\_hash) | The DedicatedServerName= value from the old servers GameUserSettings.ini. Will be set on the new server to ensure data properly loads with backup data. | `string` | `""` | no |
| <a name="input_difficulty"></a> [difficulty](#input\_difficulty) | Game difficulty setting | `string` | `"None"` | no |
| <a name="input_drop_item_alive_max_hours"></a> [drop\_item\_alive\_max\_hours](#input\_drop\_item\_alive\_max\_hours) | Maximum hours a drop item is alive | `number` | `1` | no |
| <a name="input_drop_item_max_num"></a> [drop\_item\_max\_num](#input\_drop\_item\_max\_num) | Maximum number of drop items | `number` | `3000` | no |
| <a name="input_drop_item_max_num_unko"></a> [drop\_item\_max\_num\_unko](#input\_drop\_item\_max\_num\_unko) | Maximum number of UNKO drop items | `number` | `100` | no |
| <a name="input_ebs_volume_size"></a> [ebs\_volume\_size](#input\_ebs\_volume\_size) | The size of the EBS volume attached to the EC2 instance | `number` | `40` | no |
| <a name="input_enable_aim_assist_keyboard"></a> [enable\_aim\_assist\_keyboard](#input\_enable\_aim\_assist\_keyboard) | Enable aim assist for keyboard | `bool` | `false` | no |
| <a name="input_enable_aim_assist_pad"></a> [enable\_aim\_assist\_pad](#input\_enable\_aim\_assist\_pad) | Enable aim assist for pad | `bool` | `true` | no |
| <a name="input_enable_defense_other_guild_player"></a> [enable\_defense\_other\_guild\_player](#input\_enable\_defense\_other\_guild\_player) | Enable defense against other guild players | `bool` | `false` | no |
| <a name="input_enable_fast_travel"></a> [enable\_fast\_travel](#input\_enable\_fast\_travel) | Enable fast travel | `bool` | `true` | no |
| <a name="input_enable_friendly_fire"></a> [enable\_friendly\_fire](#input\_enable\_friendly\_fire) | Enable friendly fire | `bool` | `false` | no |
| <a name="input_enable_invader_enemy"></a> [enable\_invader\_enemy](#input\_enable\_invader\_enemy) | Enable invader enemy | `bool` | `true` | no |
| <a name="input_enable_non_login_penalty"></a> [enable\_non\_login\_penalty](#input\_enable\_non\_login\_penalty) | Enable penalty for non-login | `bool` | `true` | no |
| <a name="input_enable_player_to_player_damage"></a> [enable\_player\_to\_player\_damage](#input\_enable\_player\_to\_player\_damage) | Enable player to player damage | `bool` | `false` | no |
| <a name="input_enable_rcon"></a> [enable\_rcon](#input\_enable\_rcon) | Is RCON enabled | `bool` | `false` | no |
| <a name="input_enable_s3_backups"></a> [enable\_s3\_backups](#input\_enable\_s3\_backups) | True or False. Set to true to enable backing up of the ShooterGame/Saved directory to S3 | `bool` | `false` | no |
| <a name="input_enemy_drop_item_rate"></a> [enemy\_drop\_item\_rate](#input\_enemy\_drop\_item\_rate) | Enemy drop item rate | `number` | `1` | no |
| <a name="input_exist_player_after_logout"></a> [exist\_player\_after\_logout](#input\_exist\_player\_after\_logout) | Does player exist in game after logout | `bool` | `false` | no |
| <a name="input_existing_backup_files_bootstrap_bucket_arn"></a> [existing\_backup\_files\_bootstrap\_bucket\_arn](#input\_existing\_backup\_files\_bootstrap\_bucket\_arn) | The ARN of an existing S3 bucket with ARK save game data. Files will be downloaded to the server. Objects must be in the root of the S3 bucket and not compressed. | `string` | `""` | no |
| <a name="input_existing_backup_files_bootstrap_bucket_name"></a> [existing\_backup\_files\_bootstrap\_bucket\_name](#input\_existing\_backup\_files\_bootstrap\_bucket\_name) | The Name of an existing S3 bucket with ARK save game data. Files will be downloaded to the server. Objects must be in the root of the S3 bucket and not compressed. | `string` | `""` | no |
| <a name="input_existing_ssh_key_name"></a> [existing\_ssh\_key\_name](#input\_existing\_ssh\_key\_name) | The name of an EXISTING SSH key for use with the EC2 instance | `string` | `null` | no |
| <a name="input_exp_rate"></a> [exp\_rate](#input\_exp\_rate) | Experience rate | `number` | `1` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | True or False. Set to true if you want Terraform destroy commands to have the ability to destroy the backup bucket while it still containts backup files | `bool` | `false` | no |
| <a name="input_guild_player_max_num"></a> [guild\_player\_max\_num](#input\_guild\_player\_max\_num) | Maximum number of players in a guild | `number` | `20` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type to use | `string` | `"t3.large"` | no |
| <a name="input_is_multiplay"></a> [is\_multiplay](#input\_is\_multiplay) | Is the game in multiplay mode | `bool` | `false` | no |
| <a name="input_is_pvp"></a> [is\_pvp](#input\_is\_pvp) | Is the game in PvP mode | `bool` | `false` | no |
| <a name="input_is_start_location_select_by_map"></a> [is\_start\_location\_select\_by\_map](#input\_is\_start\_location\_select\_by\_map) | Is start location selected by map | `bool` | `false` | no |
| <a name="input_night_time_speed_rate"></a> [night\_time\_speed\_rate](#input\_night\_time\_speed\_rate) | Night time speed rate | `number` | `1` | no |
| <a name="input_pal_auto_hp_regen_rate"></a> [pal\_auto\_hp\_regen\_rate](#input\_pal\_auto\_hp\_regen\_rate) | Pal auto HP regeneration rate | `number` | `1` | no |
| <a name="input_pal_auto_hp_regene_rate_in_sleep"></a> [pal\_auto\_hp\_regene\_rate\_in\_sleep](#input\_pal\_auto\_hp\_regene\_rate\_in\_sleep) | Pal auto HP regeneration rate in sleep | `number` | `1` | no |
| <a name="input_pal_capture_rate"></a> [pal\_capture\_rate](#input\_pal\_capture\_rate) | Pal capture rate | `number` | `1` | no |
| <a name="input_pal_damage_rate_attack"></a> [pal\_damage\_rate\_attack](#input\_pal\_damage\_rate\_attack) | Pal damage rate on attack | `number` | `1` | no |
| <a name="input_pal_damage_rate_defense"></a> [pal\_damage\_rate\_defense](#input\_pal\_damage\_rate\_defense) | Pal damage rate on defense | `number` | `1` | no |
| <a name="input_pal_egg_default_hatching_time"></a> [pal\_egg\_default\_hatching\_time](#input\_pal\_egg\_default\_hatching\_time) | Default hatching time for pal eggs | `number` | `72` | no |
| <a name="input_pal_spawn_num_rate"></a> [pal\_spawn\_num\_rate](#input\_pal\_spawn\_num\_rate) | Pal spawn number rate | `number` | `1` | no |
| <a name="input_pal_stamina_decrease_rate"></a> [pal\_stamina\_decrease\_rate](#input\_pal\_stamina\_decrease\_rate) | Pal stamina decrease rate | `number` | `1` | no |
| <a name="input_pal_stomach_decrease_rate"></a> [pal\_stomach\_decrease\_rate](#input\_pal\_stomach\_decrease\_rate) | Pal stomach decrease rate | `number` | `1` | no |
| <a name="input_palworldsettings_ini_path"></a> [palworldsettings\_ini\_path](#input\_palworldsettings\_ini\_path) | Path to PalWorldSettings.ini relative to your Terraform working directory. Will be uploaded to the server. Required if use\_custom\_palworldsettings = true and custom\_game\_usersettings\_s3 = true. | `string` | `""` | no |
| <a name="input_player_auto_hp_regen_rate"></a> [player\_auto\_hp\_regen\_rate](#input\_player\_auto\_hp\_regen\_rate) | Player auto HP regeneration rate | `number` | `1` | no |
| <a name="input_player_auto_hp_regen_rate_in_sleep"></a> [player\_auto\_hp\_regen\_rate\_in\_sleep](#input\_player\_auto\_hp\_regen\_rate\_in\_sleep) | Player auto HP regeneration rate in sleep | `number` | `1` | no |
| <a name="input_player_damage_rate_attack"></a> [player\_damage\_rate\_attack](#input\_player\_damage\_rate\_attack) | Player damage rate on attack | `number` | `1` | no |
| <a name="input_player_damage_rate_defense"></a> [player\_damage\_rate\_defense](#input\_player\_damage\_rate\_defense) | Player damage rate on defense | `number` | `1` | no |
| <a name="input_player_stamina_decrease_rate"></a> [player\_stamina\_decrease\_rate](#input\_player\_stamina\_decrease\_rate) | Player stamina decrease rate | `number` | `1` | no |
| <a name="input_player_stomach_decrease_rate"></a> [player\_stomach\_decrease\_rate](#input\_player\_stomach\_decrease\_rate) | Player stomach decrease rate | `number` | `1` | no |
| <a name="input_public_ip"></a> [public\_ip](#input\_public\_ip) | Public IP address | `string` | `""` | no |
| <a name="input_public_port"></a> [public\_port](#input\_public\_port) | Public port number | `number` | `8211` | no |
| <a name="input_rcon_port"></a> [rcon\_port](#input\_rcon\_port) | RCON port number | `number` | `27025` | no |
| <a name="input_region"></a> [region](#input\_region) | Server region | `string` | `""` | no |
| <a name="input_s3_bucket_backup_retention"></a> [s3\_bucket\_backup\_retention](#input\_s3\_bucket\_backup\_retention) | Lifecycle rule. The number of days to keep backups in S3 before they are deleted | `number` | `7` | no |
| <a name="input_server_description"></a> [server\_description](#input\_server\_description) | Server description | `string` | `"Running On AWS"` | no |
| <a name="input_server_name"></a> [server\_name](#input\_server\_name) | Server name | `string` | `"AWSWorldTest"` | no |
| <a name="input_server_password"></a> [server\_password](#input\_server\_password) | Server password | `string` | `"RockwellSucks"` | no |
| <a name="input_server_player_max_num"></a> [server\_player\_max\_num](#input\_server\_player\_max\_num) | Maximum number of players on server | `number` | `32` | no |
| <a name="input_ssh_ingress_allowed_cidr"></a> [ssh\_ingress\_allowed\_cidr](#input\_ssh\_ingress\_allowed\_cidr) | The CIDR range to allow SSH incoming connections from | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_ssh_key_name"></a> [ssh\_key\_name](#input\_ssh\_key\_name) | The name of the SSH key to be created for use with the EC2 instance | `string` | `"palworld-ssh-key"` | no |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | The path to the ssh public key to be used with the EC2 instance | `string` | `"~/.ssh/palworld_public_key.pub"` | no |
| <a name="input_start_from_backup"></a> [start\_from\_backup](#input\_start\_from\_backup) | True of False. Set true to start the server from an existing palworld save. Requires existing save game files. | `bool` | `false` | no |
| <a name="input_subnet_availability_zone"></a> [subnet\_availability\_zone](#input\_subnet\_availability\_zone) | The AZ of the subnet to be created within the VPC | `string` | `"us-east-1a"` | no |
| <a name="input_subnet_cidr_block"></a> [subnet\_cidr\_block](#input\_subnet\_cidr\_block) | The CIDR block of the  subnet to be created within the VPC | `string` | `"10.0.1.0/24"` | no |
| <a name="input_use_auth"></a> [use\_auth](#input\_use\_auth) | Use authentication | `bool` | `true` | no |
| <a name="input_use_custom_palworldsettings"></a> [use\_custom\_palworldsettings](#input\_use\_custom\_palworldsettings) | True or False. Set true if you want to provide your own PalWorldSettings.ini file when the server is started. Required if game\_user\_settings\_ini\_path is defined | `bool` | `false` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | The CIDR block of the VPC to be created | `string` | `"10.0.0.0/16"` | no |
| <a name="input_work_speed_rate"></a> [work\_speed\_rate](#input\_work\_speed\_rate) | Work speed rate | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backup_s3_bucket_name"></a> [backup\_s3\_bucket\_name](#output\_backup\_s3\_bucket\_name) | The Name of the S3 bucket created to store backups if enabled |
| <a name="output_custom_ini_s3_bucket_name"></a> [custom\_ini\_s3\_bucket\_name](#output\_custom\_ini\_s3\_bucket\_name) | The ID of the S3 bucket that was created if use custom ini with s3 was configured. |
| <a name="output_palworld_server_public_ip"></a> [palworld\_server\_public\_ip](#output\_palworld\_server\_public\_ip) | The public IP address of the Palworld server to connect on. |
| <a name="output_palworld_server_public_port"></a> [palworld\_server\_public\_port](#output\_palworld\_server\_public\_port) | The public port to connect to the Palworld serer on |
| <a name="output_palworldsettings_s3_content"></a> [palworldsettings\_s3\_content](#output\_palworldsettings\_s3\_content) | The contents of the palworldsettings.ini ( experimental ). |
