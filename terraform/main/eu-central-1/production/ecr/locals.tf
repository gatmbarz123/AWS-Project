locals {
  ecr_mirrors = {
    echo = {
      echo_registry_account_id = "123456789012"
      echo_registry_region     = "us-east-1"
      cache_namespace          = "echo"
      role_name                = "${var.prefix}-echo-ecr-mirror-role"
      policy_name              = "${var.prefix}-echo-ecr-mirror-policy"
    }
  }
}
