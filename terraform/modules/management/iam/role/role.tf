resource "aws_iam_role" "this" {
  name               = "${var.prefix}-${var.name}"
  assume_role_policy = var.assume_role_policy
  tags               = var.tags
}
