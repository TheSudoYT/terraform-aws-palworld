## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | >=3.4.1 |
| <a name="requirement_template"></a> [template](#requirement\_template) | >=2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.33.0 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.palworld_server_ip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_instance_profile.instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.instance_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.instance_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_instance.palworld_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.ssh_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_s3_bucket.palworld](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.palworld_bootstrap](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_versioning.palworld](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_versioning.palworld_bootstrap](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_object.bootstrap_level_savegame_files](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.bootstrap_player_savegame_files](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.palworldsettings](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.players_directory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_security_group_rule.allow_ssh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.palworld_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [template_file.user_data_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

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
| <a name="input_create_ssh_key"></a> [create\_ssh\_key](#input\_create\_ssh\_key) | True or False. Determines if an SSH key is created in AWS | `bool` | `true` | no |
| <a name="input_custom_palworldsettings_github"></a> [custom\_palworldsettings\_github](#input\_custom\_palworldsettings\_github) | True or False. Set true if use\_custom\_palworldsettings is true and you want to download them from github. Must be a public repo. | `bool` | `false` | no |
| <a name="input_custom_palworldsettings_github_url"></a> [custom\_palworldsettings\_github\_url](#input\_custom\_palworldsettings\_github\_url) | The URL to the PalWorldSettings.ini file on a public GitHub repo. Used when custom\_palworldsettings\_github and custom\_game\_usersettings both == true. | `string` | `""` | no |
| <a name="input_custom_palworldsettings_s3"></a> [custom\_palworldsettings\_s3](#input\_custom\_palworldsettings\_s3) | True or False. Set true if use\_custom\_palworldsettings is true and you want to upload and download them from an S3 bucket during installation | `bool` | `false` | no |
| <a name="input_day_time_speed_rate"></a> [day\_time\_speed\_rate](#input\_day\_time\_speed\_rate) | Day time speed rate | `number` | `1` | no |
| <a name="input_death_penalty"></a> [death\_penalty](#input\_death\_penalty) | Death penalty setting. 0 = None : No lost, 1 = Item : Lost item without equipment, 2= ItemAndEquipment : Lost item and equipment, 3= All : Lost All item, equipment, pal(in inventory) | `number` | `1` | no |
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
| <a name="input_existing_backup_files_bootstrap_bucket_arn"></a> [existing\_backup\_files\_bootstrap\_bucket\_arn](#input\_existing\_backup\_files\_bootstrap\_bucket\_arn) | The ARN of an existing S3 bucket with Palworld save game data. Files will be downloaded to the server. Objects must be in the root of the S3 bucket and not compressed. | `string` | `""` | no |
| <a name="input_existing_backup_files_bootstrap_bucket_name"></a> [existing\_backup\_files\_bootstrap\_bucket\_name](#input\_existing\_backup\_files\_bootstrap\_bucket\_name) | The Name of an existing S3 bucket with Palworld save game data. Files will be downloaded to the server. Objects must be in the root of the S3 bucket and not compressed. | `string` | `""` | no |
| <a name="input_existing_ssh_key_name"></a> [existing\_ssh\_key\_name](#input\_existing\_ssh\_key\_name) | The name of an EXISTING SSH key for use with the EC2 instance | `string` | `null` | no |
| <a name="input_exp_rate"></a> [exp\_rate](#input\_exp\_rate) | Experience rate | `number` | `1` | no |
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
| <a name="input_palworld_security_group_id"></a> [palworld\_security\_group\_id](#input\_palworld\_security\_group\_id) | The ID of the security group to use with the EC2 instance | `string` | `""` | no |
| <a name="input_palworld_subnet_id"></a> [palworld\_subnet\_id](#input\_palworld\_subnet\_id) | The ID of the security group to use with the EC2 instance | `string` | `""` | no |
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
| <a name="input_server_description"></a> [server\_description](#input\_server\_description) | Server description | `string` | `"Running On AWS"` | no |
| <a name="input_server_name"></a> [server\_name](#input\_server\_name) | Server name | `string` | `"AWSWorldTest"` | no |
| <a name="input_server_password"></a> [server\_password](#input\_server\_password) | Server password | `string` | `"RockwellSucks"` | no |
| <a name="input_server_player_max_num"></a> [server\_player\_max\_num](#input\_server\_player\_max\_num) | Maximum number of players on server | `number` | `32` | no |
| <a name="input_ssh_ingress_allowed_cidr"></a> [ssh\_ingress\_allowed\_cidr](#input\_ssh\_ingress\_allowed\_cidr) | The CIDR range to allow SSH incoming connections from | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_ssh_key_name"></a> [ssh\_key\_name](#input\_ssh\_key\_name) | The name of the SSH key to be created for use with the EC2 instance | `string` | `"palworld-ssh-key"` | no |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | The path to the ssh public key to be used with the EC2 instance | `string` | `"~/.ssh/palworld_public_key.pub"` | no |
| <a name="input_start_from_backup"></a> [start\_from\_backup](#input\_start\_from\_backup) | True of False. Set true to start the server from an existing palworld save. Requires existing save game files. | `bool` | `false` | no |
| <a name="input_use_auth"></a> [use\_auth](#input\_use\_auth) | Use authentication | `bool` | `true` | no |
| <a name="input_use_custom_palworldsettings"></a> [use\_custom\_palworldsettings](#input\_use\_custom\_palworldsettings) | True or False. Set true if you want to provide your own PalWorldSettings.ini file when the server is started. Required if game\_user\_settings\_ini\_path is defined | `bool` | `false` | no |
| <a name="input_work_speed_rate"></a> [work\_speed\_rate](#input\_work\_speed\_rate) | Work speed rate | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_custom_ini_s3_bucket_name"></a> [custom\_ini\_s3\_bucket\_name](#output\_custom\_ini\_s3\_bucket\_name) | The ID of the S3 bucket that was created if use custom ini with s3 was configured. |
| <a name="output_custom_palworldsettings_file_name"></a> [custom\_palworldsettings\_file\_name](#output\_custom\_palworldsettings\_file\_name) | The custom palworldsettings file name that was uploaded to s3 if use custom GUS ini with s3 was configured. |
| <a name="output_palworld_server_public_ip"></a> [palworld\_server\_public\_ip](#output\_palworld\_server\_public\_ip) | The public IP address of the Palworld server to connect on. |
| <a name="output_palworld_server_public_port"></a> [palworld\_server\_public\_port](#output\_palworld\_server\_public\_port) | The public port to connect to the Palworld sevrer on. |
| <a name="output_palworldsettings_s3_bucket"></a> [palworldsettings\_s3\_bucket](#output\_palworldsettings\_s3\_bucket) | The download URI of the palworldsettings.ini from s3 ( experimental ). |
| <a name="output_palworldsettings_s3_content"></a> [palworldsettings\_s3\_content](#output\_palworldsettings\_s3\_content) | The contents of the palworldsettings.ini ( experimental ). |
| <a name="output_server_using_custom_palworldsettingsini"></a> [server\_using\_custom\_palworldsettingsini](#output\_server\_using\_custom\_palworldsettingsini) | Is the server using custom palworldsettings.ini. |
| <a name="output_ssh_key_name"></a> [ssh\_key\_name](#output\_ssh\_key\_name) | The name of the SSH key generated by Terraform. |
