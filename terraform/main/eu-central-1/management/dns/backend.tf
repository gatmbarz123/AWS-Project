terraform {
  backend "s3" {
    bucket = "mng-euc1-example-tf-state"
    region = "eu-central-1"
    key    = "dns/terraform.tfstate"
  }
}