# Backups to S3 Enabled
This is an example configuring Ark to backup to S3

## Details
This module includes the option to enable backups. Use `enable_s3_backups = true`. Enabling this will backup the `ShooterGame/Saved` directory to an S3 bucket at the interval specified using cron. Backups will be retained in S3 based on the number of days specified by the input `s3_bucket_backup_retention`.

2 Files will be created on the ark server; `ark_backup_script.sh` on install and `ark_backup_log.log` when the first backup job runs. The backup log should show similiar to the one below if backup is a success:

```bash
ubuntu@ip-10-0-1-250:/ark-asa$ ls
Engine  Manifest_DebugFiles_Win64.txt  Manifest_NonUFSFiles_Win64.txt  Manifest_UFSFiles_Win64.txt  ShooterGame  ark_backup_log.log  ark_backup_script.sh  compatibilitytools.d  linux64  steamapps  steamclient.so
ubuntu@ip-10-0-1-250:/ark-asa$ cat ark_backup_log.log 
[INFO] Creating Ark Backup
tar: Removing leading `/' from member names
/ark-asa/ShooterGame/Saved/
/ark-asa/ShooterGame/Saved/SavedArks/
/ark-asa/ShooterGame/Saved/SavedArks/TheIsland_WP/
/ark-asa/ShooterGame/Saved/SavedArks/TheIsland_WP/TheIsland_WP.ark
/ark-asa/ShooterGame/Saved/Logs/
/ark-asa/ShooterGame/Saved/Logs/ShooterGame.log
/ark-asa/ShooterGame/Saved/Logs/FailedWaterDinoSpawns.log
/ark-asa/ShooterGame/Saved/Config/
/ark-asa/ShooterGame/Saved/Config/CrashReportClient/
/ark-asa/ShooterGame/Saved/Config/CrashReportClient/UECC-Windows-9D515DBA45100CBD707E679881FCDE73/
/ark-asa/ShooterGame/Saved/Config/CrashReportClient/UECC-Windows-9D515DBA45100CBD707E679881FCDE73/CrashReportClient.ini
/ark-asa/ShooterGame/Saved/Config/WindowsServer/
/ark-asa/ShooterGame/Saved/Config/WindowsServer/GameUserSettings.ini
/ark-asa/ShooterGame/Saved/Config/WindowsServer/Game.ini
[INFO] Uploading Ark Backup to s3
upload: ./ark-aws-ascended_backup_2024-01-01-18-47-04.tar.gz to s3://ark-backups-12345678912345/ark-aws-ascended_backup_2024-01-01-18-47-04.tar.gz
[INFO] Removing Local Ark Backup File
```

> [!Note]  
> You can calculate a cron expression here: https://crontab.guru/#*/5_*_*_*_*

## Usage
Relevant inputs:

```HCL
  enable_s3_backups          = true
  create_backup_s3_bucket    = true
  backup_s3_bucket_arn       = ""
  backup_s3_bucket_name      = ""
  s3_bucket_backup_retention = 7
  force_destroy              = true
  backup_interval_cron_expression              = "*/5 * * * *"
``` 
