# Custom PalWorldSettings.ini From S3
This is an example of using the inputs `use_custom_palworldsettings` with `custom_palworldsettings_s3` set true.

## Details
Enabling custom .ini files with S3 will create an S3 bucket with your custom .ini files uploaded to it. The EC2 instance will download these files from s3 upon first startup to use with Palworld when it starts.

> [!WARNING]
> Any of the inputs that are also settings in the PalWorldSettings.ini file will be ignored if `use_custom_palworldsettings = true`. For example, if you say `exp_rate = 3.0` and also say  `use_custom_palworldsettings = true` then the value in your custom PalWorldSettings.ini will be used and the value of exp_rate will be ignored.

## Usage
Relevant inputs:

```HCL
  use_custom_palworldsettings        = true
  custom_palworldsettings_s3         = true
  palworldsettings_ini_path        = "../../TestPalWorldSettings.ini"
```