resource "aws_iam_user" "user" {
  name = var.user_name
  tags = var.tags
}

resource "aws_iam_user_policy_attachment" "managed" {
  for_each = toset(var.policy_arns)

  user       = aws_iam_user.user.name
  policy_arn = each.value
}

resource "aws_iam_user_policy" "inline" {
  for_each = var.inline_policies

  name   = each.key
  user   = aws_iam_user.user.name
  policy = each.value
}

resource "aws_iam_access_key" "key" {
  user = aws_iam_user.user.name
}

resource "aws_secretsmanager_secret" "credentials" {
  name = "${var.secret_name_prefix}/${var.user_name}/credentials"
  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "credentials" {
  secret_id = aws_secretsmanager_secret.credentials.id
  secret_string = jsonencode({
    access_key_id     = aws_iam_access_key.key.id
    secret_access_key = aws_iam_access_key.key.secret
  })
}
