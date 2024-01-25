resource "aws_s3_bucket" "palworld" {
  count = var.use_custom_palworldsettings == true && var.custom_palworldsettings_s3 == true ? 1 : 0

  bucket = "palworld-app-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}"

}

resource "aws_s3_bucket_versioning" "palworld" {
  count = var.use_custom_palworldsettings == true && var.custom_palworldsettings_s3 == true ? 1 : 0

  bucket = aws_s3_bucket.palworld[0].id

  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_object" "palworldsettings" {
  count = var.use_custom_palworldsettings == true && var.custom_palworldsettings_s3 == true ? 1 : 0

  bucket = aws_s3_bucket.palworld[0].id
  key    = "PalWorldSettings.ini"
  source = var.palworldsettings_ini_path
}


### Start From Backup ###
resource "aws_s3_bucket" "palworld_bootstrap" {
  count = var.start_from_backup == true && var.backup_files_storage_type == "local" ? 1 : 0

  bucket = "palworld-bootstrap-local-saves-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}"

}

resource "aws_s3_bucket_versioning" "palworld_bootstrap" {
  count = var.start_from_backup == true && var.backup_files_storage_type == "local" ? 1 : 0

  bucket = aws_s3_bucket.palworld_bootstrap[0].id

  versioning_configuration {
    status = "Disabled"
  }
}

locals {
  level_files  = var.start_from_backup == true && var.backup_files_storage_type == "local" ? fileset(var.backup_files_local_path, "*") : []
  player_files = var.start_from_backup == true && var.backup_files_storage_type == "local" ? fileset("${var.backup_files_local_path}/Players", "*") : []
}

resource "aws_s3_object" "bootstrap_level_savegame_files" {
  for_each = { for f in local.level_files : f => f }

  bucket = aws_s3_bucket.palworld_bootstrap[0].id
  key    = basename(each.value)
  source = "${var.backup_files_local_path}/${each.value}"
}

resource "aws_s3_object" "players_directory" {
  count = var.start_from_backup == true && var.backup_files_storage_type == "local" ? 1 : 0

  bucket = aws_s3_bucket.palworld_bootstrap[0].id
  key    = "Players/"
}

resource "aws_s3_object" "bootstrap_player_savegame_files" {
  for_each = { for f in local.player_files : f => f }

  bucket = aws_s3_bucket.palworld_bootstrap[0].id
  key    = "Players/${basename(each.value)}"
  source = "${var.backup_files_local_path}/Players/${each.value}"

  depends_on = [aws_s3_object.players_directory]
}