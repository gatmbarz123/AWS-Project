resource "aws_iam_role_policy" "policies" {
  name   = var.name
  role   = var.role_name
  policy = var.policy_file
}
