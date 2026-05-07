terraform {
  backend "s3" {
    bucket = "prod-usgw1-example-platform-tf-state"
    region = "us-gov-west-1"
    key    = "storage/terraform.tfstate"
  }
}