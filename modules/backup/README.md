## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.31.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.ark_backup_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_versioning.ark_backup_versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_backup_s3_bucket"></a> [create\_backup\_s3\_bucket](#input\_create\_backup\_s3\_bucket) | True or False. Do you want to create an S3 bucket to FTP backups into | `bool` | `false` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | True or False. Set to true if you want Terraform destroy commands to have the ability to destroy the backup bucket while it still containts backup files | `bool` | `false` | no |
| <a name="input_s3_bucket_backup_retention"></a> [s3\_bucket\_backup\_retention](#input\_s3\_bucket\_backup\_retention) | Lifecycle rule. The number of days to keep backups in S3 before they are deleted | `number` | `7` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backup_s3_bucket_arn"></a> [backup\_s3\_bucket\_arn](#output\_backup\_s3\_bucket\_arn) | n/a |
| <a name="output_backup_s3_bucket_name"></a> [backup\_s3\_bucket\_name](#output\_backup\_s3\_bucket\_name) | n/a |
