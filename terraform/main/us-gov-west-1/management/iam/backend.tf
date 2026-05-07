terraform {
  backend "s3" {
    bucket = "mng-usgw1-example-tf-state"
    region = "us-gov-west-1"
    key    = "iam/terraform.tfstate"
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      # Environment = "${var.environment}"
      Region    = "${var.region}"
      ManagedBy = "Terraform"
    }
  }
}
