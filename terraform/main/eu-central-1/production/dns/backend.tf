terraform {
  backend "s3" {
    bucket = "prod-euc1-example-platform-tf-state"
    region = "eu-central-1"
    key    = "dns/terraform.tfstate"
  }
}