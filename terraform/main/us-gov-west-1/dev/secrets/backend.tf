terraform {
  backend "s3" {
    bucket = "dev-usgw1-example-platform-tf-state"
    region = "us-gov-west-1"
    key    = "secrets/terraform.tfstate"
  }
}