terraform {
  backend "s3" {
    bucket = "prod-usgw1-example-platform-tf-state"
    region = "us-gov-west-1"
    key    = "security/terraform.tfstate"
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
