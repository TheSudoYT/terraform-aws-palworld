resource "aws_key_pair" "ssh_key" {
  count = var.create_ssh_key == true ? 1 : 0

  key_name   = var.ssh_key_name
  public_key = file(var.ssh_public_key)
}

# Allow inbound traffic to the EC2 instance on necessary ports
resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.ssh_ingress_allowed_cidr
  security_group_id = var.palworld_security_group_id

}

resource "aws_instance" "palworld_server" {

  lifecycle {
    precondition {
      condition     = var.use_custom_palworldsettings == true ? var.use_custom_palworldsettings == true && var.custom_palworldsettings_s3 == true && var.custom_palworldsettings_github == false || var.use_custom_palworldsettings == true && var.custom_palworldsettings_s3 == false && var.custom_palworldsettings_github == true : var.use_custom_palworldsettings == false && var.custom_palworldsettings_s3 == false && var.custom_palworldsettings_github == false
      error_message = "Cannot use a custom palworldsettings.ini file from s3 and github at the same time OR you have custom_palworldsettings_s3 defined but use_custom_palworldsettings false."
    }
  }

  ami                    = var.ami_id != null ? var.ami_id : data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.create_ssh_key == true ? aws_key_pair.ssh_key[0].key_name : var.existing_ssh_key_name
  subnet_id              = var.palworld_subnet_id
  vpc_security_group_ids = [var.palworld_security_group_id]

  user_data = data.template_file.user_data_template.rendered

  iam_instance_profile = var.custom_palworldsettings_s3 == true && length(aws_iam_instance_profile.instance_profile) > 0 || var.enable_s3_backups == true && length(aws_iam_instance_profile.instance_profile) > 0 || var.start_from_backup == true && length(aws_iam_instance_profile.instance_profile) > 0 ? aws_iam_instance_profile.instance_profile[0].name : null


  root_block_device {
    volume_size = var.ebs_volume_size
  }

  tags = {
    Name = var.server_name
  }
}

resource "aws_eip" "palworld_server_ip" {
  instance = aws_instance.palworld_server.id
}