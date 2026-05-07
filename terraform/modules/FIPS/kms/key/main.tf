resource "aws_kms_key" "this" {
  description              = var.description
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation      = true
  rotation_period_in_days  = var.rotation_period_in_days
  deletion_window_in_days  = var.deletion_window_in_days
  multi_region             = var.multi_region
  tags                     = var.tags
}

resource "aws_kms_alias" "this" {
  count         = var.alias != null && var.alias != "" ? 1 : 0
  name          = "alias/${var.alias}"
  target_key_id = aws_kms_key.this.key_id
}