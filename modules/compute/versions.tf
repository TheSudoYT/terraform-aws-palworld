terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
    template = {
      source  = "hashicorp/template"
      version = ">=2.2.0"
    }
    http = {
      source  = "hashicorp/http"
      version = ">=3.4.1"
    }
  }
}
