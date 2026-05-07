terraform {
  required_version = "<= 1.6.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region

  endpoints {
    rds  = "https://rds-fips.${var.region}.amazonaws.com"
    kms  = "https://kms-fips.${var.region}.amazonaws.com"
    sts  = "https://sts-fips.${var.region}.amazonaws.com"
    iam  = "https://iam-fips.amazonaws.com"
    logs = "https://logs-fips.${var.region}.amazonaws.com"
  }

  default_tags {
    tags = {
      Environment = "${var.environment}"
      Region      = "${var.region}"
      ManagedBy   = "Terraform"
    }
  }
}