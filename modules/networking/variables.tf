### Networking Variables ###
variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC to be created"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  description = "The CIDR block of the  subnet to be created within the VPC"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_availability_zone" {
  description = "The AZ of the subnet to be created within the VPC"
  type        = string
  default     = "us-east-1a"
}

### Security Group Variables ###
variable "enable_rcon" {
  description = "True or False. Enable RCON or not"
  type        = bool
  default     = false
}

variable "rcon_port" {
  description = "The port number that RCON listens on if enabled"
  type        = number
  default     = null
}

variable "public_port" {
  description = "Public port number"
  type        = number
  default     = 8211
}

variable "enable_ssh" {
  description = "True or False. Determines if SSH and port 22 are enabled or not"
  type        = bool
  default     = true
}

variable "ssh_ingress_allowed_cidr" {
  description = "The CIDR range to allow SSH incoming connections from"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
