terraform {
  backend "s3" {
    bucket = "mng-use1-example-tf-state"
    region = "us-east-1"
    key    = "iam/terraform.tfstate"
  }
}