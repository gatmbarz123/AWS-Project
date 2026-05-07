terraform {
  backend "s3" {
    bucket = "dev-euc1-example-platform-tf-state"
    region = "eu-central-1"
    key    = "network/terraform.tfstate"
  }
}