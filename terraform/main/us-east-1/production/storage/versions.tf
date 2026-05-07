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
    s3  = "https://s3-fips.us-east-1.amazonaws.com"
    kms = "https://kms-fips.us-east-1.amazonaws.com"
    iam = "https://iam-fips.amazonaws.com"
    sts = "https://sts-fips.us-east-1.amazonaws.com"
  }

  default_tags {
    tags = {
      Environment = "${var.environment}"
      Region      = "${var.region}"
      ManagedBy   = "Terraform"
    }
  }
}