resource "aws_iam_role" "instance_role" {
  count = var.custom_palworldsettings_s3 == true || var.start_from_backup == true || var.enable_s3_backups == true ? 1 : 0

  name               = "palworld-instance-role-${data.aws_region.current.name}"
  path               = "/"
  assume_role_policy = file("${path.module}/templates/palworld-instance-role.json")
}

resource "aws_iam_role_policy" "instance_role_policy" {
  count = var.use_custom_palworldsettings == true && var.custom_palworldsettings_s3 == true || var.start_from_backup == true || var.enable_s3_backups == true ? 1 : 0

  name   = "palworld-instance-role-policy-${data.aws_region.current.name}"
  policy = data.aws_iam_policy_document.palworld_policy[0].json

  role = aws_iam_role.instance_role[0].id
}


resource "aws_iam_instance_profile" "instance_profile" {
  count = var.use_custom_palworldsettings == true && var.custom_palworldsettings_s3 == true || var.start_from_backup == true || var.enable_s3_backups == true ? 1 : 0

  name = "palworld-instance-profile-${data.aws_region.current.name}"
  path = "/"
  role = aws_iam_role.instance_role[0].name
}

data "aws_iam_policy_document" "palworld_policy" {
  count = var.use_custom_palworldsettings == true && var.custom_palworldsettings_s3 == true || var.start_from_backup == true || var.enable_s3_backups == true == true ? 1 : 0
  statement {
    sid = "InteractWithS3"

    actions = [
      "s3:PutObject",
      "s3:ListBucket",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:GetBucketLocation",
    ]

    resources = compact([
      var.custom_palworldsettings_s3 == true ? aws_s3_bucket.palworld[0].arn : "",
      var.custom_palworldsettings_s3 == true ? "${aws_s3_bucket.palworld[0].arn}/*" : "",
      var.enable_s3_backups == true ? var.backup_s3_bucket_arn : "",
      var.enable_s3_backups == true ? "${var.backup_s3_bucket_arn}/*" : "",
      var.start_from_backup == true && var.backup_files_storage_type == "local" ? aws_s3_bucket.palworld_bootstrap[0].arn : "",
      var.start_from_backup == true && var.backup_files_storage_type == "local" ? "${aws_s3_bucket.palworld_bootstrap[0].arn}/*" : "",
      var.start_from_backup == true && var.backup_files_storage_type == "s3" ? var.existing_backup_files_bootstrap_bucket_arn : "",
      var.start_from_backup == true && var.backup_files_storage_type == "s3" ? "${var.existing_backup_files_bootstrap_bucket_arn}/*" : "",
    ])
  }
}
