# Custom PalWorldSettings.ini and Game.ini From GitHub
This is an example of using the inputs `use_custom_palworldsettings` with `custom_palworldsettings_github` true.

## Details
Enabling custom ini files with GitHub will instruct the EC2 server to download the .ini files from the GitHub URL specified to be used with Palworld when it starts.

> [!IMPORTANT]  
> The URL provided should be a GitHub RAW URL from a PUBLIC repository.

## Usage
Relevant inputs:

```HCL
  instance_type               = "t3.large"
  create_ssh_key              = true
  ssh_public_key              = "../../palworld_public_key.pub"
  use_custom_palworldsettings = true
  custom_palworldsettings_s3  = false
  custom_palworldsettings_github     = true
  custom_palworldsettings_github_url = "https://raw.githubusercontent.com/TheSudoYT/terraform-aws-palwolrd/initial/TestPalWorldSettings.ini?token=GHSAT0AAAAAACLHVUVTFCHETVPC3XAVTGICZMVYWWQ"
``` 
