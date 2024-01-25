module "palworld" {
  source = "../.."

  instance_type                      = "t3.large"
  create_ssh_key                     = true
  ssh_public_key                     = "../../palworld_public_key.pub"
  use_custom_palworldsettings        = true
  custom_palworldsettings_s3         = false
  custom_palworldsettings_github     = true
  custom_palworldsettings_github_url = "https://raw.githubusercontent.com/TheSudoYT/terraform-aws-palwolrd/initial/TestPalWorldSettings.ini?token=GHSAT0AAAAAACLHVUVTFCHETVPC3XAVTGICZMVYWWQ"
}
