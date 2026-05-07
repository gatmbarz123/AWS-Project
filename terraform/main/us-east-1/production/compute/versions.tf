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
    eks    = "https://fips.eks.${var.region}.amazonaws.com"
    iam    = "https://iam-fips.amazonaws.com"
    kms    = "https://kms-fips.${var.region}.amazonaws.com"
    logs   = "https://logs-fips.${var.region}.amazonaws.com"
    ec2    = "https://ec2-fips.${var.region}.amazonaws.com"
    sqs    = "https://sqs-fips.${var.region}.amazonaws.com"
    events = "https://events-fips.${var.region}.amazonaws.com"
    sts    = "https://sts-fips.${var.region}.amazonaws.com"
    s3     = "https://s3-fips.${var.region}.amazonaws.com"
    ssm    = "https://ssm-fips.${var.region}.amazonaws.com"
    ecr    = "https://ecr-fips.${var.region}.amazonaws.com"
  }

  default_tags {
    tags = {
      Environment = "${var.environment}"
      Region      = "${var.region}"
      ManagedBy   = "Terraform"
    }
  }
}