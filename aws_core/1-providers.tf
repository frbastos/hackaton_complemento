provider "aws" {
  region  = local.region
}

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>5.79"
    }
  }

  backend "s3" {
    bucket = "fiap-terraform-state-eks"
    region = "us-east-1"
    key = "state/terraform.tfstate"
  }
}

