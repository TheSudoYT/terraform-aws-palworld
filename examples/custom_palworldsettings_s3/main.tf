module "palworld" {
  source = "../.."

  instance_type               = "t3.large"
  create_ssh_key              = true
  ssh_public_key              = "../../palworld_public_key.pub"
  use_custom_palworldsettings = true
  custom_palworldsettings_s3  = true
  palworldsettings_ini_path   = "../../TestPalWorldSettings.ini"
}
