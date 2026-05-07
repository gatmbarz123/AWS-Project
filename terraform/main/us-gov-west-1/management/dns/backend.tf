terraform {
  backend "s3" {
    bucket = "mng-usgw1-example-tf-state"
    region = "us-gov-west-1"
    key    = "dns/terraform.tfstate"
  }
}