# Using SSM Instead of SSH
This example demonstrates enabling SSM and disabling SSH. AWS Systems Manager Session Manager is a web based way to connect to an instance from your browser instead of over SSH. It is more secure than enabling port 22 and SSH. 

Once you connect with SSM run the command `sudo su ubuntu` to assume the ubuntu user if desired. 

> [!NOTE]
> SSH and SSM can be used together is you wish.

## Usage

Relevent Inputs:

```HCL
 module "palworld" {
  source = "../.."


  instance_type                             = "t3.xlarge"
  create_ssh_key                            = false
  ssh_public_key                            = ""
  enable_ssh                                = false
  enable_session_manager                    = true
  server_name                               = "Egghead-Island"
  server_description                        = "Kaizoku ou ni ore wa naru"
 }
```

`enable_session_manager                    = true`
`enable_ssh                                = false`
`create_ssh_key                            = false`
`ssh_public_key                            = ""`
