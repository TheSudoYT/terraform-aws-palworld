# Backups to S3 Enabled
This is an example configuring Palworld to backup to S3

## Details
This module includes the option to enable backups. Use `enable_s3_backups = true`. Enabling this will backup the `Pal/Saved/SaveGame` directory to an S3 bucket at the interval specified using cron. Backups will be retained in S3 based on the number of days specified by the input `s3_bucket_backup_retention`.

2 Files will be created on the Palworld server; `palworld_backup_script.sh` on install and `palworld_backup_log.log` when the first backup job runs.

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
