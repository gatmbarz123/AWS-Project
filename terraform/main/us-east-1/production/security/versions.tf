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

  # FIPS 140-2 Compliance: Use FIPS endpoints for all security services
  endpoints {
    cloudtrail = "https://cloudtrail-fips.${var.region}.amazonaws.com"
    config     = "https://config-fips.${var.region}.amazonaws.com"
    wafv2      = "https://wafv2-fips.${var.region}.amazonaws.com"
    guardduty  = "https://guardduty-fips.${var.region}.amazonaws.com"
    kms        = "https://kms-fips.${var.region}.amazonaws.com"
    s3         = "https://s3-fips.${var.region}.amazonaws.com"
    sts        = "https://sts-fips.${var.region}.amazonaws.com"
    iam        = "https://iam-fips.amazonaws.com"
    logs       = "https://logs-fips.${var.region}.amazonaws.com"
    sns        = "https://sns-fips.${var.region}.amazonaws.com"
    events     = "https://events-fips.${var.region}.amazonaws.com"
  }

  default_tags {
    tags = {
      Environment = "${var.environment}"
      Region      = "${var.region}"
      ManagedBy   = "Terraform"
    }
  }
}