# Vanilla Ark with Default Settings
This example demonstrates all that is required to launch ASA with all default settings.

> [!NOTE]
> Please change the `ark_session_name`.

## Usage
Relevant inputs:

```HCL
  ge_proton_version = "8-27"
  instance_type     = "t3.xlarge"
  create_ssh_key    = true
  ssh_public_key    = "../../ark_public_key.pub"
  ark_session_name      = "ark-aws-ascended"
```
