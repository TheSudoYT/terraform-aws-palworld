module "asa" {
  source = "TheSudoYT/ark-survival-ascended/aws"

  ge_proton_version = "8-27"
  instance_type     = "t3.xlarge"
  create_ssh_key    = true
  ssh_public_key    = "../../ark_public_key.pub"
  ark_session_name  = "ark-aws-ascended"
}
