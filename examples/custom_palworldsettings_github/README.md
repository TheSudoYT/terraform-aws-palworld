# Custom GameUserSettings.ini and Game.ini From GitHub
This is an example of using the inputs `use_custom_gameusersettings` and `use_custom_game_ini` with `custom_gameusersettings_github` and `custom_gameini_github` set true.

## Details
Enabling custom ini files with GitHub will instruct the EC2 server to download the .ini files from the GitHub URL specified to be used with Ark when it starts.

> [!IMPORTANT]  
> The URL provided should be a GitHub RAW URL from a PUBLIC repository.

## Usage
Relevant inputs:

```HCL
  use_custom_gameusersettings        = true
  custom_gameusersettings_github     = true
  custom_gameusersettings_github_url = "https://raw.githubusercontent.com/TheSudoYT/ark-aws-ascended-infra/initial/TestGameUserSettings.ini?token=GHSAT0AAAAAACLHVUVTFCHETVPC3XAVTGICZMVYWWQ"
  use_custom_game_ini       = true
  custom_gameini_github     = true
  custom_gameini_github_url = "https://raw.githubusercontent.com/TheSudoYT/ark-aws-ascended-infra/initial/TestGame.ini?token=GHSAT0AAAAAACLHVUVTSLPHAJ32H24IUCP4ZMVYWUA"
``` 
