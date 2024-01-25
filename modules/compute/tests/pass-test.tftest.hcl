

provider "aws" {}

variables {
  instance_type  = "t3.large"
  create_ssh_key = false
  ssh_public_key = ""
}

// Validate PalWorldSettings.ini object when using custom ini with s3
run "pass_validate_custom_ini_files_s3" {

  command = plan

  variables {
    use_custom_palworldsettings        = true
    custom_palworldsettings_s3         = true
    palworldsettings_ini_path          = "../../../TestPalWorldSettings.ini"
    custom_palworldsettings_github     = false
    custom_palworldsettings_github_url = ""

  }

  # Check that PalWorldSettings.ini object expected to exist in s3
  assert {
    condition     = aws_s3_object.palworldsettings[0].key == "PalWorldSettings.ini"
    error_message = "Invalid PalWorldSettings.ini in S3 or does not exist in S3 when its expected to."
  }
}

// Just make sure an s3 bucket is not created
run "pass_validate_custom_ini_files_github" {

  command = plan

  variables {
    use_custom_palworldsettings        = true
    custom_palworldsettings_s3         = false
    palworldsettings_ini_path          = "../../../TestPalWorldSettings.ini"
    custom_palworldsettings_github     = true
    custom_palworldsettings_github_url = "https://raw.githubusercontent.com/TheSudoYT/palworld-aws-ascended-infra/initial/TestPalWorldSettings.ini?token=GHSAT0AAAAAACLHVUVTFCHETVPC3XAVTGICZMVYWWQ"
  }


  # Check that PalWorldSettings.ini object expected to exist in s3
  assert {
    condition     = length(aws_s3_bucket.palworld) == 0
    error_message = "S3 bucket attempting to be created when an S3 bucket is not expected to be created."
  }
}

// Validate e2e without custom ini files declared. Palworld uses default ini files its instatiated with.
run "pass_validate_no_custom_ini_files_s3" {

  command = plan

  variables {
    use_custom_palworldsettings        = false
    custom_palworldsettings_s3         = false
    palworldsettings_ini_path          = ""
    custom_palworldsettings_github     = false
    custom_palworldsettings_github_url = ""
  }

  assert {
    condition     = length(aws_s3_bucket.palworld) == 0
    error_message = "An s3 bucket is being created for a .ini file when none is expected."
  }

}

run "pass_validate_rcon_false_password" {

  command = plan

  variables {
    enable_rcon    = false
    rcon_port      = null
    public_port    = 8211
    admin_password = "RockwellSucks"
  }

  // Test enable_rcon = false with null rcon_port
  assert {
    condition     = var.enable_rcon == true && var.rcon_port != null || var.enable_rcon == false && var.rcon_port == null
    error_message = "rcon_port is defined when enable_rcon = false. rcon_port must be null unless enable_rcon = true."
  }

  // Test enable_rcon = false with admin_password set
  assert {
    condition     = var.enable_rcon == true && var.admin_password != "" || var.enable_rcon == false
    error_message = "admin_password must be set when enable_rcon = true"
  }
}

run "pass_validate_rcon_true_password" {

  command = plan

  variables {
    enable_rcon    = true
    rcon_port      = 27025
    public_port    = 8211
    admin_password = "RockwellSucks"
  }

  // Test enable_rcon = true with defined rcon_port
  assert {
    condition     = var.enable_rcon == true && var.rcon_port != null || var.enable_rcon == false && var.rcon_port == null
    error_message = "rcon_port is defined when enable_rcon = false. rcon_port must be null unless enable_rcon = true."
  }

  // Test enable_rcon = true with admin_password set
  assert {
    condition     = var.enable_rcon == true && var.admin_password != "" || var.enable_rcon == false
    error_message = "admin_password must be set when enable_rcon = true"
  }
}