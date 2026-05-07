terraform {
  backend "s3" {
    bucket = "stg-euc1-example-platform-tf-state"
    region = "eu-central-1"
    key    = "datadog/terraform.tfstate"
  }
}