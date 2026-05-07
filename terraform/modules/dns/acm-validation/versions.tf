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
  default_tags {
    tags = {
      Environment = "${var.environment}"
      Region      = "${var.region}"
      ManagedBy   = "Terraform"
    }
  }
}

provider "aws" {
  region = var.region
  alias  = "management"
  assume_role {
    role_arn = "arn:${data.aws_partition.current.partition}:iam::${var.management_account_id}:role/${var.management_role_name}"
  }
  default_tags {
    tags = {
      Environment = "${var.environment}"
      Region      = "${var.region}"
      ManagedBy   = "Terraform"
    }
  }
}
