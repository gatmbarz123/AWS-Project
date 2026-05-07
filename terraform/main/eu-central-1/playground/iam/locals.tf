locals {
  iam_roles = {
    github-oidc-s3-role = {
      assume_role_policy = templatefile("${var.policy_iam_path}/github_trust_relationship_policy.json.tpl",
        {
          ACCOUNT_ID = var.aws_account_id
          REPO_NAME  = "copilot"
        }
      )
    }
  }
  iam_inline_policies = {
    S3Access = {
      role_name = "github-oidc-s3-role"
      policy_file = templatefile("${var.policy_iam_path}/s3_read_write_access.json.tpl",
        {
          BUCKET_NAME = "${var.prefix}-example-test-data"
        }
      )
    }
  }
}

