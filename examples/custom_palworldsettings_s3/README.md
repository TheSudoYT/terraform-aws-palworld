# Custom GameUserSettings.ini and Game.ini From S3
This is an example of using the inputs `use_custom_gameusersettings` and `use_custom_game_ini` with `custom_gameusersettings_s3` and `custom_gameini_s3` set true.

## Details
Enabling custom ini files with S3 will create an S3 bucket with your custom .ini files uploaded to it. The EC2 instance will download these files from s3 upon first startup to use with Ark when it starts.

## Usage
Relevant inputs:

```HCL
  use_custom_gameusersettings        = true
  custom_gameusersettings_s3         = true
  game_user_settings_ini_path        = "../../TestGameUserSettings.ini"
  use_custom_game_ini       = true
  custom_gameini_s3         = true
  game_ini_path             = "../../TestGame.ini"
```
