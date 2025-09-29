terraform {

    required_version = ">= 0.13.0"

    required_providers {
        civo = {
            source  = "civo/civo"
            version = ">= 1.0.13"
        }
    }
}

variable "civo_token" {
    description = "Civo API Token"
    type        = string
    sensitive   = true
}

provider "civo" {
    token = var.civo_token
    region = "FRA1"
}