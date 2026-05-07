terraform {
  backend "s3" {
    bucket = "prod-use1-example-platform-tf-state"
    region = "us-east-1"
    key    = "database/terraform.tfstate"
  }
}