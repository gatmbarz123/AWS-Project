module "s3_cmk" {
  source                  = "../../../../modules/FIPS/kms/key"
  description             = var.kms_description
  alias                   = "${var.prefix}-${var.kms_alias}"
  rotation_period_in_days = var.kms_rotation_period_in_days
  deletion_window_in_days = var.kms_deletion_window_in_days
  multi_region            = var.kms_multi_region
  tags                    = var.tags
}

module "s3" {
  source = "../../../../modules/FIPS/storage/s3-fips/bucket"

  prefix = var.prefix

  for_each = var.s3_buckets

  name                  = each.key
  versioning_status     = lookup(each.value, "versioning_status", "Disabled")
  enable_logging        = lookup(each.value, "enable_logging", false)
  logging_target_bucket = lookup(each.value, "logging_target_bucket", null)
  logging_target_prefix = lookup(each.value, "logging_target_prefix", null)

  # KMS / FIPS: use shared CMK by default; allow per-bucket override via kms_key_id in tfvars
  kms_key_id = lookup(each.value, "kms_key_id", module.s3_cmk.key_arn)

  tags = var.tags
}
