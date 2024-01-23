terraform {
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = ">=3.4.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

variable "ge_proton_version" {
  type        = string
  description = "The GE proton version to test"
}

data "http" "ge_proton" {
  url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/tag/GE-Proton${var.ge_proton_version}"
}

check "ge_proton_version_check" {
  data "http" "ge_proton_2" {
    url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/tag/GE-Proton${var.ge_proton_version}"
  }

  assert {
    condition     = data.http.ge_proton.status_code == 200
    error_message = "${data.http.ge_proton.url} returned an unhealthy status code for version ${var.ge_proton_version}"
  }
}
