#!/bin/bash

# Create directories
mkdir /opt/steam
mkdir /palworld-server

# Install software
echo "[INFO] INSTALLING SOFTWARE"
apt-get update
apt-get install -y curl lib32gcc1 lsof git awscli

# Install steam cmd
echo "[INFO] DOWNLOADING AND INSTALLING STEAM CMD"
wget -P /opt/steam https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
tar -xzf /opt/steam/steamcmd_linux.tar.gz -C /opt/steam 
chmod 755 /opt/steam/steamcmd.sh

# Create steam user
echo "[INFO] CREATING STEAM USER"
useradd -m -U steam
chown -R steam:steam /palworld-server

# Setup the steam cmd command to download Palworld
echo "[INFO] SETTING UP STEAMCMD INSTALLER TO DOWNLOAD PALWORLD"
chown -R steam:steam /opt/steam
cat <<EOF > /opt/steam/download-palworld.txt
@NoPromptForPassword 1
force_install_dir /palworld-server
login anonymous 
app_update 2394010 validate
quit
EOF

# Run steam cmd to download PALWORLD
echo "[INFO] DOWNLOADING PALWORLD"
sudo -u steam /opt/steam/steamcmd.sh +runscript /opt/steam/download-palworld.txt

sudo -u steam mkdir -p /home/steam/.steam/sdk64/
sudo -u steam /opt/steam/steamcmd.sh +login anonymous +app_update 1007 +quit

# Give steamcmd.sh time to do its magic before trying to copy the files that above command downloads
sleep 30

sudo -u steam cp /home/steam/Steam/steamapps/common/Steamworks\ SDK\ Redist/linux64/steamclient.so /home/steam/.steam/sdk64/

# Install the systemd service file for PALWORLD Dedicated Server
echo "[INFO] CREATING SYSTEMD SERVICE PALWORLD"
cat > /etc/systemd/system/palworld.service <<EOF
[Unit]
Description=Palworld Dedicated Server
After=network.target

[Service]
Type=simple
LimitNOFILE=10000
User=steam
Group=steam
ExecStartPre=/opt/steam/steamcmd.sh +runscript /opt/steam/download-palworld.txt
WorkingDirectory=/palworld-server
ExecStart=/palworld-server/PalServer.sh EpicApp=PalServer

Restart=on-failure
RestartSec=20s

[Install]
WantedBy=multi-user.target
EOF

if [[ ${use_custom_palworldsettings} == "false" ]]; then
mkdir -p /palworld-server/Pal/Saved/Config/LinuxServer/
cat > /palworld-server/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini <<EOF
[/Script/Pal.PalGameWorldSettings]
OptionSettings=(Difficulty="${difficulty}",
DayTimeSpeedRate=${day_time_speed_rate},
NightTimeSpeedRate=${night_time_speed_rate},
ExpRate=${exp_rate},
PalCaptureRate=${pal_capture_rate},
PalSpawnNumRate=${pal_spawn_num_rate},
PalDamageRateAttack=${pal_damage_rate_attack},
PalDamageRateDefense=${pal_damage_rate_defense},
PlayerDamageRateAttack=${player_damage_rate_attack},
PlayerDamageRateDefense=${player_damage_rate_defense},
PlayerStomachDecreaceRate=${player_stomach_decrease_rate},
PlayerStaminaDecreaceRate=${player_stamina_decrease_rate},
PlayerAutoHPRegeneRate=${player_auto_hp_regen_rate},
PlayerAutoHpRegeneRateInSleep=${player_auto_hp_regen_rate_in_sleep},
PalStomachDecreaceRate=${pal_stomach_decrease_rate},
PalStaminaDecreaceRate=${pal_stamina_decrease_rate},
PalAutoHPRegeneRate=${pal_auto_hp_regen_rate},
PalAutoHpRegeneRateInSleep=${pal_auto_hp_regene_rate_in_sleep},
BuildObjectDamageRate=${build_object_damage_rate},
BuildObjectDeteriorationDamageRate=${build_object_deterioration_damage_rate},
CollectionDropRate=${collection_drop_rate},
CollectionObjectHpRate=${collection_object_hp_rate},
CollectionObjectRespawnSpeedRate=${collection_object_respawn_speed_rate},
EnemyDropItemRate=${enemy_drop_item_rate},
DeathPenalty=${death_penalty},
bEnablePlayerToPlayerDamage=${enable_player_to_player_damage},
bEnableFriendlyFire=${enable_friendly_fire},
bEnableInvaderEnemy=${enable_invader_enemy},
bActiveUNKO=${active_unko},
bEnableAimAssistPad=${enable_aim_assist_pad},
bEnableAimAssistKeyboard=${enable_aim_assist_keyboard},
DropItemMaxNum=${drop_item_max_num},
DropItemMaxNum_UNKO=${drop_item_max_num_unko},
BaseCampMaxNum=${base_camp_max_num},
BaseCampWorkerMaxNum=${base_camp_worker_max_num},
DropItemAliveMaxHours=${drop_item_alive_max_hours},
bAutoResetGuildNoOnlinePlayers=${auto_reset_guild_no_online_players},
AutoResetGuildTimeNoOnlinePlayers=${auto_reset_guild_time_no_online_players},
GuildPlayerMaxNum=${guild_player_max_num},
PalEggDefaultHatchingTime=${pal_egg_default_hatching_time},
WorkSpeedRate=${work_speed_rate},
bIsMultiplay=${is_multiplay},
bIsPvP=${is_pvp},
bCanPickupOtherGuildDeathPenaltyDrop=${can_pickup_other_guild_death_penalty_drop},
bEnableNonLoginPenalty=${enable_non_login_penalty},
bEnableFastTravel=${enable_fast_travel},
bIsStartLocationSelectByMap=${is_start_location_select_by_map},
bExistPlayerAfterLogout=${exist_player_after_logout},
bEnableDefenseOtherGuildPlayer=${enable_defense_other_guild_player},
CoopPlayerMaxNum=${coop_player_max_num},
ServerPlayerMaxNum=${server_player_max_num},
ServerName="${server_name}",
ServerDescription="${server_description}",
AdminPassword="${admin_password}",
ServerPassword="${server_password}",
PublicPort=${public_port},
PublicIP="${public_ip}",
RCONEnabled=${enable_rcon},
RCONPort=${rcon_port},
Region="${region}",
bUseAuth=${use_auth},
BanListURL="${ban_list_url}")
EOF
fi

# Function for getting palworldsettings from S3
retrieve_obj_from_s3() {
  local src="$1"
  local dst="/palworld-server/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini"

  echo "[INFO] GETTING PalWorldSettings.ini FROM S3"

  if [[ "$src" == "" ]]; then
    echo "[ERROR] Did not detect a valid path."
    exit_script 10
  else
    echo "[INFO] Copying $src to $dst..."
    aws s3 cp "$src" "$dst"
    chown steam:steam /palworld-server/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
  fi
}

# Function for getting palworldsettings from GitHub raw
retrieve_obj_from_github() {
  local src="$1"
  local dst="/palworld-server/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini"

  echo "[INFO] GETTING palworldsettings.ini FROM GITHUB"

  if [[ "$src" == "" ]]; then
    echo "[ERROR] Did not detect a valid path."
    exit_script 10
  else
    echo "[INFO] Copying $src to $dst..."
    curl "$src" --create-dirs -o "$dst"
    chown steam:steam /palworld-server/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
  fi
}

handle_palworldsettings() {
    local use_custom_palworldsettings="$1"
    local custom_palworldsettings_s3="$2"
    local custom_palworldsettings_github="$3"
    local palworldsettings_bucket_arn="$4"
    local github_url="$5"

    echo "[INFO] CHECKING FOR CUSTOM palworldsettings.ini OPTIONS"
    echo "[INFO] use_custom_palworldsettings SET TO $use_custom_palworldsettings"
    echo "[INFO] custom_palworldsettings_s3 SET TO $custom_palworldsettings_s3"
    echo "[INFO] custom_palworldsettings_github SET TO $custom_palworldsettings_github"
    echo "[INFO] palworldsettings_bucket_arn SET TO $palworldsettings_bucket_arn"
    echo "[INFO] github_url SET TO $github_url"

    if [[ $use_custom_palworldsettings == "true" ]]; then
        if [[ $custom_palworldsettings_s3 == "true" && $custom_palworldsettings_github == "true" ]]; then
            echo "Error: Both custom_palworldsettings_s3 and custom_palworldsettings_github cannot be true simultaneously."
        elif [[ $custom_palworldsettings_s3 == "true" ]]; then
            echo "[INFO] custom_palworldsettings_s3 == true"
            retrieve_obj_from_s3 "$palworldsettings_bucket_arn"
        elif [[ $custom_palworldsettings_github == "true" ]]; then
            echo "[INFO] custom_palworldsettings_github == true"
            retrieve_obj_from_github "$github_url"
        else
            echo "Error: Invalid configuration for use_custom_palworldsettings."
        fi
    fi
}

##
# DONT FORGET TO PARAMETERIZE THE MAP NAME WHEN YOU DO MULTIPLE MAPS!! ##
#####
# Function for getting save game files from S3
retrieve_obj_from_s3_backup() {
  local src="$1"
  local dst="/palworld-server/Pal/Saved/SaveGames"

  echo "[INFO] GETTING SAVE BACKUP FILES FROM S3"

  if [[ "$src" == "" ]]; then
    echo "[ERROR] Did not detect a valid path."
    exit_script 10
  else
    echo "[INFO] Copying $src to $dst..."
    aws s3 sync "$src" "$dst"
  fi
}

handle_start_from_backup() {
    local start_from_backup="$1"
    local backup_files_storage_type="$2"
    local backup_files_local_path="$3"
    local backup_files_bootstrap_bucket_name="$4"
    local backup_files_s3_bucket_uri="$5"

    echo "[INFO] CHECKING FOR START_FROM_BACKUP OPTIONS"
    echo "[INFO] start_from_backup SET TO $start_from_backup"
    echo "[INFO] backup_files_storage_type SET TO $backup_files_storage_type"
    echo "[INFO] backup_files_local_path SET TO $backup_files_local_path"
    echo "[INFO] backup_files_s3_bucket_uri SET TO $backup_files_s3_bucket_uri"

    if [[ $start_from_backup == "true" ]]; then
        if [[ $backup_files_storage_type == "local" ]]; then
            echo "[INFO] backup_files_storage_type == local"
            retrieve_obj_from_s3_backup "$backup_files_bootstrap_bucket_name"
        elif [[ $backup_files_storage_type == "s3" ]]; then
            echo "[INFO] backup_files_storage_type == s3"
            # to do
            retrieve_obj_from_existing_s3 "$backup_files_s3_bucket_uri"
        else
            echo "Error: Invalid configuration for start_from_backup"
        fi
    fi
}

if [[ ${start_from_backup} == "true" ]]; then
echo "[INFO] START FROM EXISTING SAVE DATA/BACKUP REQUESTED FOR USE"
handle_start_from_backup ${start_from_backup} ${backup_files_storage_type} ${backup_files_local_path} ${backup_files_bootstrap_bucket_name} ${backup_files_s3_bucket_uri}
fi

if [[ ${use_custom_palworldsettings} == "true" ]]; then
echo "[INFO] CUSTOM palworldsettings.INI REQUESTED FOR USE"
handle_palworldsettings ${use_custom_palworldsettings} ${custom_palworldsettings_s3} ${custom_palworldsettings_github} ${palworldsettings_bucket_arn} ${github_url}
fi


chown -R steam:steam /palworld-server/Pal/Saved
chmod -R 775 /palworld-server/Pal/Saved
# Upload custom palworldsettings.ini if user has use_custom_palworldsettings true and game_user_settings_ini_path defined
# %{ if use_custom_palworldsettings == "true" && custom_palworldsettings_s3 == "true" ~}
# retrieve_obj_from_s3 "${palworldsettings_bucket_arn}"
# %{ endif ~} 
# %{ if use_custom_palworldsettings == "true" && custom_palworldsettings_github == "true" ~}
# retrieve_obj_from_github "${palworldsettings_bucket_arn}"
# %{ endif ~}

# Start and enable the PALWORLD service
systemctl daemon-reload
echo "[INFO] ENABLING PALWORLD.SERVICE"
systemctl enable palworld
echo "[INFO] STARTING PALWORLD.SERVICE"
systemctl start palworld

if [[ ${enable_s3_backups} == "true" ]]; then
echo "[INFO] S3 BBACKUPS ENABLED. CREATING /palworld-server/palworld_backup_script.sh"
cat > /palworld-server/palworld_backup_script.sh <<EOD
#!/bin/bash

# Backup variables
DIR_TO_BACKUP="/palworld-server/Pal/Saved/SaveGames"
S3_BUCKET_NAME="${backup_s3_bucket_name}"

generate_timestamp() {
date '+%Y-%m-%d-%H-%M-%S'
}

TIMESTAMP="\$(generate_timestamp)"
BACKUP_FILENAME="${server_name}_backup_"\$TIMESTAMP".tar.gz"

# Create backup
echo "[INFO] Creating palworld Backup"
tar -zcvf "\$BACKUP_FILENAME" "\$DIR_TO_BACKUP"

# Upload backup to S3
echo "[INFO] Uploading palworld Backup to s3"
aws s3 cp "\$BACKUP_FILENAME" s3://"\$S3_BUCKET_NAME"/

# Remove local backup file
echo "[INFO] Removing Local palworld Backup File"
rm "\$BACKUP_FILENAME"
EOD

chmod +x /palworld-server/palworld_backup_script.sh

(crontab -l -u steam 2>/dev/null; echo "${backup_interval_cron_expression} /palworld-server/palworld_backup_script.sh >> /palworld-server/palworld_backup_log.log 2>&1") | crontab -u steam -
fi
