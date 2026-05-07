data "aws_ssoadmin_instances" "this" {}

resource "aws_ssoadmin_account_assignment" "account_assignment" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn = var.permission_set_arn

  principal_id   = var.sso_group_id
  principal_type = "GROUP"

  target_id   = var.account_id # The AWS account ID
  target_type = "AWS_ACCOUNT"
}
