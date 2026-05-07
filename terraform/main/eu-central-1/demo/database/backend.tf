terraform {
  backend "s3" {
    bucket = "demo-euc1-example-platform-tf-state"
    region = "eu-central-1"
    key    = "database/terraform.tfstate"
  }
}