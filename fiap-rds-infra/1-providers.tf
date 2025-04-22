provider "aws" {
  region = local.region
}

provider "postgresql" {
  host     = aws_db_instance.processadordb.address
  port     = 5432
  username = "postgres"
  password = local.rds_password
  sslmode  = "require"
}

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.79"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.25.0"
    }
  }

  backend "s3" {
    bucket = "fiap-terraform-state-rds"
    region = "us-east-1"
    key    = "state/terraform.tfstate"
  }
}
