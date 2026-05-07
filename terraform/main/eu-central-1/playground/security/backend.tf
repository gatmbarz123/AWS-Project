terraform {
  backend "s3" {
    bucket = "play-euc1-example-platform-tf-state"
    region = "eu-central-1"
    key    = "security/terraform.tfstate"
  }
}