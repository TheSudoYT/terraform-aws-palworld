output "vpc_id" {
  value       = aws_vpc.palworld_vpc.id
  description = "The ID of the VPC created by Terraform."
}

output "subnet_id" {
  value       = aws_subnet.palworld_subnet.id
  description = "The subnet ID of the subnet created by Terraform."
}

output "security_group_id" {
  value       = aws_security_group.palworld_security_group.id
  description = "The security group ID of the security group created by Terraform."
}
