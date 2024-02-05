module "palworld" {
  source = "../.."


  instance_type          = "t3.xlarge"
  create_ssh_key         = false
  ssh_public_key         = ""
  enable_ssh             = false
  enable_session_manager = true
  server_name            = "Egghead-Island"
  server_description     = "Kaizoku ou ni ore wa naru"
}
